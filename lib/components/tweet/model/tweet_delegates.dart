import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/components/components.dart';

part 'tweet_delegates.freezed.dart';

/// Delegates used by the [TweetCard] and its content.
@freezed
class TweetDelegates with _$TweetDelegates {
  const factory TweetDelegates({
    required TweetActionCallback? onTweetTap,
    required TweetActionCallback? onUserTap,
    required TweetActionCallback? onRetweeterTap,
    required TweetActionCallback? onViewActions,
    required TweetActionCallback? onFavorite,
    required TweetActionCallback? onUnfavorite,
    required TweetActionCallback? onRetweet,
    required TweetActionCallback? onUnretweet,
    required TweetActionCallback? onTranslate,
    required TweetActionCallback? onShowRetweeters,
    required TweetActionCallback? onComposeQuote,
    required TweetActionCallback? onComposeReply,
  }) = _TweetDelegates;
}
