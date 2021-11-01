import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:http/http.dart';

part 'tweet_bloc_action_mixin.dart';
part 'tweet_event.dart';
part 'tweet_state.dart';

/// Handles actions done on a single tweet, such as retweeting, favoriting,
/// translating, etc.
class TweetBloc extends Bloc<TweetEvent, TweetState>
    with TweetBlocActionCallback {
  TweetBloc(this.tweet) : super(const TweetState()) {
    on<TweetEvent>((event, emit) => event.handle(this, emit));
  }

  /// Reference to the tweet that is used to display a tweet card.
  ///
  /// The [TweetData] is mutable and changes from actions that are done on the
  /// tweet will affect the source data.
  final TweetData tweet;

  void onTweetTap() {
    app<HarpyNavigator>().pushTweetDetailScreen(tweet: tweet);
  }

  void onUserTap(BuildContext context) {
    final route = ModalRoute.of(context);

    assert(route != null);

    app<HarpyNavigator>().pushUserProfile(
      currentRoute: route?.settings,
      screenName: tweet.user.handle,
    );
  }

  void onRetweeterTap(BuildContext context) {
    final route = ModalRoute.of(context);

    assert(route != null);
    assert(tweet.retweetUserHandle != null);

    if (tweet.retweetUserHandle != null) {
      app<HarpyNavigator>().pushUserProfile(
        currentRoute: route?.settings,
        screenName: tweet.retweetUserHandle!,
      );
    }
  }

  void onViewMoreActions(BuildContext context) {
    showTweetActionsBottomSheet(context, tweet: tweet);
  }

  void onRetweet() {
    HapticFeedback.lightImpact();
    add(const RetweetTweet());
  }

  void onUnretweet() {
    HapticFeedback.lightImpact();
    add(const UnretweetTweet());
  }

  void onComposeQuote() {
    app<HarpyNavigator>().pushComposeScreen(quotedTweet: tweet);
  }

  void onFavorite() {
    HapticFeedback.lightImpact();
    add(const FavoriteTweet());
  }

  void onUnfavorite() {
    HapticFeedback.lightImpact();
    add(const UnfavoriteTweet());
  }

  void onTranslate(Locale locale) {
    HapticFeedback.lightImpact();
    add(TranslateTweet(locale: locale));

    _invoke(TweetAction.translate);
  }

  void onReplyToTweet() {
    app<HarpyNavigator>().pushComposeScreen(inReplyToStatus: tweet);
  }
}
