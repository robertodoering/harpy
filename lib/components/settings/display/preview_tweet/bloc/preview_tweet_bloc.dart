import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet_data.dart';
import 'package:harpy/components/common/tweet/bloc/tweet_bloc.dart';

/// Overrides delegates in the [TweetBloc] to prevent requests when want to use
/// a preview / mock tweet card.
class PreviewTweetBloc extends TweetBloc {
  PreviewTweetBloc(
    TweetData tweet, {
    this.enableUserTap = false,
  }) : super(tweet);

  final bool enableUserTap;

  @override
  void onTweetTap() {}

  @override
  void onUserTap(BuildContext context) {
    if (enableUserTap) {
      super.onUserTap(context);
    }
  }

  @override
  void onRetweeterTap(BuildContext context) {}

  @override
  void onViewMoreActions(BuildContext context) {}

  @override
  void onRetweet() {}

  @override
  void onUnretweet() {}

  @override
  void onComposeQuote() {}

  @override
  void onFavorite() {}

  @override
  void onUnfavorite() {}

  @override
  void onTranslate(Locale locale) {}

  @override
  void onReplyToTweet() {}
}
