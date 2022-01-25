import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet_data.dart';
import 'package:harpy/components/common/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';

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
      // We don't use super.onUserTap since it expects a fully hydrated user
      // object which we don't have in the preview bloc.
      // By only passing the handle we will load the user data on navigation.
      app<HarpyNavigator>().pushUserProfile(
        handle: tweet.user.handle,
      );
    }
  }

  @override
  void onRetweeterTap(BuildContext context) {}

  @override
  void onViewMoreActions(BuildContext context) {}

  @override
  void onToggleRetweet() {}

  @override
  void onUnretweet() {}

  @override
  void onComposeQuote() {}

  @override
  void onShowRetweeters() {}

  @override
  void onFavorite() {}

  @override
  void onUnfavorite() {}

  @override
  void onTranslate(Locale locale) {}

  @override
  void onReplyToTweet() {}
}
