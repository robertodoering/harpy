import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

part 'tweet_delegates.freezed.dart';

typedef TweetActionCallback = void Function(WidgetRef ref);

typedef MediaActionCallback = void Function(WidgetRef ref, MediaData media);

/// Delegates used by the [TweetCard] and its content.
@freezed
class TweetDelegates with _$TweetDelegates {
  const factory TweetDelegates({
    TweetActionCallback? onShowTweet,
    TweetActionCallback? onShowUser,
    TweetActionCallback? onShowRetweeter,
    TweetActionCallback? onFavorite,
    TweetActionCallback? onUnfavorite,
    TweetActionCallback? onRetweet,
    TweetActionCallback? onUnretweet,
    TweetActionCallback? onTranslate,
    TweetActionCallback? onShowRetweeters,
    TweetActionCallback? onComposeQuote,
    TweetActionCallback? onComposeReply,
    TweetActionCallback? onDelete,
    TweetActionCallback? onOpenTweetExternally,
    TweetActionCallback? onCopyText,
    TweetActionCallback? onShareTweet,
    MediaActionCallback? onOpenMediaExternally,
    MediaActionCallback? onDownloadMedia,
    MediaActionCallback? onShareMedia,
  }) = _TweetDelegates;
}

TweetDelegates defaultTweetDelegates(
  LegacyTweetData tweet,
  TweetNotifier notifier,
) {
  return TweetDelegates(
    onShowTweet: (ref) => ref.read(routerProvider).pushNamed(
          TweetDetailPage.name,
          params: {'handle': tweet.user.handle, 'id': tweet.id},
          extra: tweet,
        ),
    onShowUser: (ref) {
      final router = ref.read(routerProvider);

      if (!router.location.endsWith(tweet.user.handle)) {
        router.pushNamed(
          UserPage.name,
          params: {'handle': tweet.user.handle},
        );
      }
    },
    onShowRetweeter: (ref) {
      final router = ref.read(routerProvider);

      if (!router.location.endsWith(tweet.retweeter!.handle)) {
        router.pushNamed(
          UserPage.name,
          params: {'handle': tweet.retweeter!.handle},
        );
      }
    },
    onFavorite: (_) {
      HapticFeedback.lightImpact();
      notifier.favorite();
    },
    onUnfavorite: (_) {
      HapticFeedback.lightImpact();
      notifier.unfavorite();
    },
    onRetweet: (_) {
      HapticFeedback.lightImpact();
      notifier.retweet();
    },
    onUnretweet: (_) {
      HapticFeedback.lightImpact();
      notifier.unretweet();
    },
    onTranslate: (ref) {
      HapticFeedback.lightImpact();
      notifier.translate(locale: Localizations.localeOf(ref.context));
    },
    onShowRetweeters: tweet.retweetCount > 0
        ? (ref) => ref.read(routerProvider).pushNamed(
              RetweetersPage.name,
              params: {'handle': tweet.user.handle, 'id': tweet.id},
            )
        : null,
    onComposeQuote: (ref) => ref.read(routerProvider).pushNamed(
      ComposePage.name,
      extra: {'quotedTweet': tweet},
    ),
    onComposeReply: (ref) => ref.read(routerProvider).pushNamed(
      ComposePage.name,
      extra: {'parentTweet': tweet},
    ),
    onDelete: (ref) {
      HapticFeedback.lightImpact();
      notifier.delete(
        onDeleted: () =>
            ref.read(homeTimelineProvider.notifier).removeTweet(tweet),
      );
    },
    onOpenTweetExternally: (ref) {
      HapticFeedback.lightImpact();
      ref.read(launcherProvider)(tweet.tweetUrl, alwaysOpenExternally: true);
    },
    onCopyText: (ref) {
      HapticFeedback.lightImpact();
      Clipboard.setData(ClipboardData(text: tweet.visibleText));
      ref.read(messageServiceProvider).showText('copied tweet text');
    },
    onShareTweet: (ref) {
      HapticFeedback.lightImpact();
      Share.share(tweet.tweetUrl);
    },
    onOpenMediaExternally: (ref, media) {
      HapticFeedback.lightImpact();
      ref.read(launcherProvider)(media.bestUrl, alwaysOpenExternally: true);
    },
    onDownloadMedia: _downloadMedia,
    onShareMedia: (_, media) {
      HapticFeedback.lightImpact();
      Share.share(media.bestUrl);
    },
  );
}

Future<void> _downloadMedia(
  WidgetRef ref,
  MediaData media,
) async {
  var name = filenameFromUrl(media.bestUrl) ?? 'media';

  final storagePermission = await Permission.storage.request();

  if (!storagePermission.isGranted) {
    ref.read(messageServiceProvider).showText('storage permission not granted');
    return;
  }

  if (ref.read(mediaPreferencesProvider).showDownloadDialog) {
    // ignore: use_build_context_synchronously
    final customName = await showDialog<String>(
      context: ref.context,
      builder: (_) => DownloadDialog(
        initialName: name,
        type: media.type,
      ),
    );

    if (customName != null) {
      name = customName;
    } else {
      // user cancelled the download dialog
      return;
    }
  }

  await ref.read(downloadPathProvider.notifier).initialize();
  final path = ref.read(downloadPathProvider).fullPathForType(media.type);

  if (path == null) {
    assert(false);
    return;
  }

  await ref.read(downloadServiceProvider).download(
        url: media.bestUrl,
        name: name,
        path: path,
      );

  ref.read(messageServiceProvider).showText('download started');
}
