import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

part 'tweet_delegates.freezed.dart';

typedef TweetActionCallback = void Function(
  BuildContext context,
  Reader read,
);

typedef MediaActionCallback = void Function(
  BuildContext context,
  Reader read,
  MediaData media,
);

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
  TweetData tweet,
  TweetNotifier notifier,
) {
  return TweetDelegates(
    onShowTweet: (context, read) => read(routerProvider).pushNamed(
      TweetDetailPage.name,
      params: {'handle': tweet.user.handle, 'id': tweet.id},
      extra: tweet,
    ),
    onShowUser: (_, read) {
      final router = read(routerProvider);

      if (!router.location.endsWith(tweet.user.handle)) {
        router.pushNamed(
          UserPage.name,
          params: {'handle': tweet.user.handle},
          extra: tweet.user,
        );
      }
    },
    onShowRetweeter: (_, read) {
      final router = read(routerProvider);

      if (!router.location.endsWith(tweet.retweeter!.handle)) {
        router.pushNamed(
          UserPage.name,
          params: {'handle': tweet.retweeter!.handle},
          extra: tweet.retweeter,
        );
      }
    },
    onFavorite: (_, __) {
      HapticFeedback.lightImpact();
      notifier.favorite();
    },
    onUnfavorite: (_, __) {
      HapticFeedback.lightImpact();
      notifier.unfavorite();
    },
    onRetweet: (_, __) {
      HapticFeedback.lightImpact();
      notifier.retweet();
    },
    onUnretweet: (_, __) {
      HapticFeedback.lightImpact();
      notifier.unretweet();
    },
    onTranslate: (context, _) {
      HapticFeedback.lightImpact();
      notifier.translate(locale: Localizations.localeOf(context));
    },
    onShowRetweeters: tweet.retweetCount > 0
        ? (_, read) => read(routerProvider).pushNamed(
              RetweetersPage.name,
              params: {'handle': tweet.user.handle, 'id': tweet.id},
            )
        : null,
    onComposeQuote: (_, read) => read(routerProvider).pushNamed(
      ComposePage.name,
      extra: {'quotedTweet': tweet},
    ),
    onComposeReply: (_, read) => read(routerProvider).pushNamed(
      ComposePage.name,
      extra: {'parentTweet': tweet},
    ),
    onDelete: (_, read) {
      HapticFeedback.lightImpact();
      notifier.delete(
        onDeleted: () => read(homeTimelineProvider.notifier).removeTweet(tweet),
      );
    },
    onOpenTweetExternally: (context, read) {
      HapticFeedback.lightImpact();
      read(launcherProvider)(tweet.tweetUrl);
    },
    onCopyText: (context, read) {
      HapticFeedback.lightImpact();
      Clipboard.setData(ClipboardData(text: tweet.visibleText));
      read(messageServiceProvider).showText('copied tweet text');
    },
    onShareTweet: (context, read) {
      HapticFeedback.lightImpact();
      Share.share(tweet.tweetUrl);
    },
    onOpenMediaExternally: (_, read, media) {
      HapticFeedback.lightImpact();
      read(launcherProvider)(media.bestUrl);
    },
    onDownloadMedia: _downloadMedia,
    onShareMedia: (_, __, media) {
      HapticFeedback.lightImpact();
      Share.share(media.bestUrl);
    },
  );
}

Future<void> _downloadMedia(
  BuildContext context,
  Reader read,
  MediaData media,
) async {
  var name = filenameFromUrl(media.bestUrl) ?? 'media';

  final storagePermission = await Permission.storage.request();

  if (!storagePermission.isGranted) {
    read(messageServiceProvider).showText('storage permission not granted');
    return;
  }

  if (read(mediaPreferencesProvider).showDownloadDialog) {
    final customName = await showDialog<String>(
      context: context,
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

  await read(downloadPathProvider.notifier).initialize();
  final path = read(downloadPathProvider).fullPathForType(media.type);

  if (path == null) {
    assert(false);
    return;
  }

  await read(downloadServiceProvider).download(
    url: media.bestUrl,
    name: name,
    path: path,
  );

  read(messageServiceProvider).showText('download started');
}
