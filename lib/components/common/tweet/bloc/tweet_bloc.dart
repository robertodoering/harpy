import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:dart_twitter_api/api/tweets/tweet_service.dart';
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
import 'package:pedantic/pedantic.dart';
import 'package:share/share.dart';

part 'tweet_bloc_action_mixin.dart';
part 'tweet_event.dart';
part 'tweet_state.dart';

/// Handles actions done on a single tweet, such as retweeting, favoriting,
/// translating, etc.
class TweetBloc extends Bloc<TweetEvent, TweetState>
    with TweetBlocActionCallback {
  TweetBloc(TweetData tweet) : super(TweetState(tweet: tweet));

  final TweetService tweetService = app<TwitterApi>().tweetService;
  final TranslationService translationService = app<TranslationService>();
  final LanguagePreferences languagePreferences = app<LanguagePreferences>();

  void onTweetTap() {
    app<HarpyNavigator>().pushTweetDetailScreen(tweet: state.tweet);
  }

  void onUserTap(BuildContext context) {
    final route = ModalRoute.of(context);

    assert(route != null);

    app<HarpyNavigator>().pushUserProfile(
      currentRoute: route?.settings,
      screenName: state.tweet.user.handle,
    );
  }

  void onRetweeterTap(BuildContext context) {
    final route = ModalRoute.of(context);

    assert(route != null);
    assert(state.tweet.retweetUserHandle != null);

    if (state.tweet.retweetUserHandle != null) {
      app<HarpyNavigator>().pushUserProfile(
        currentRoute: route?.settings,
        screenName: state.tweet.retweetUserHandle!,
      );
    }
  }

  void onViewMoreActions(BuildContext context) {
    showTweetActionsBottomSheet(context, tweet: state.tweet);
  }

  void onRetweet() {
    unawaited(HapticFeedback.lightImpact());
    add(const RetweetTweet());
  }

  void onUnretweet() {
    unawaited(HapticFeedback.lightImpact());
    add(const UnretweetTweet());
  }

  void onComposeQuote() {
    app<HarpyNavigator>().pushComposeScreen(quotedTweet: state.tweet);
  }

  void onFavorite() {
    unawaited(HapticFeedback.lightImpact());
    add(const FavoriteTweet());
  }

  void onUnfavorite() {
    unawaited(HapticFeedback.lightImpact());
    add(const UnfavoriteTweet());
  }

  void onTranslate(Locale locale) {
    unawaited(HapticFeedback.lightImpact());
    add(TranslateTweet(locale: locale));

    _invoke(TweetAction.translate);
  }

  void onReplyToTweet() {
    app<HarpyNavigator>().pushComposeScreen(inReplyToStatus: state.tweet);
  }

  @override
  Stream<TweetState> mapEventToState(
    TweetEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
