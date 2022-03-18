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
    required TweetActionCallback? onShowTweet,
    required TweetActionCallback? onShowUser,
    required TweetActionCallback? onShowRetweeter,
    required TweetActionCallback? onFavorite,
    required TweetActionCallback? onUnfavorite,
    required TweetActionCallback? onRetweet,
    required TweetActionCallback? onUnretweet,
    required TweetActionCallback? onTranslate,
    required TweetActionCallback? onShowRetweeters,
    required TweetActionCallback? onComposeQuote,
    required TweetActionCallback? onComposeReply,
    required TweetActionCallback? onDelete,
    required TweetActionCallback? onOpenTweetExternally,
    required TweetActionCallback? onCopyText,
    required TweetActionCallback? onShareTweet,
    required MediaActionCallback? onOpenMediaExternally,
    required MediaActionCallback? onDownloadMedia,
    required MediaActionCallback? onShareMedia,
  }) = _TweetDelegates;
}

TweetDelegates defaultTweetDelegates(
  TweetData tweet,
  TweetNotifier notifier,
) {
  // TODO: implement all tweet delegates
  return TweetDelegates(
    onShowTweet: (context, read) => read(routerProvider).pushNamed(
      TweetDetailPage.name,
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
              params: {'id': tweet.originalId},
            )
        : null,
    onComposeQuote: null,
    onComposeReply: null,
    onDelete: (_, read) {
      HapticFeedback.lightImpact();
      notifier.delete(
        onDeleted: () => read(homeTimelineProvider.notifier).removeTweet(tweet),
      );
    },
    onOpenTweetExternally: (context, read) {
      HapticFeedback.lightImpact();
      launchUrl(tweet.tweetUrl);
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
    onOpenMediaExternally: (_, __, media) {
      HapticFeedback.lightImpact();
      launchUrl(media.bestUrl);
    },
    onDownloadMedia: _downloadMedia,
    onShareMedia: (context, read, media) {
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
