import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

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
