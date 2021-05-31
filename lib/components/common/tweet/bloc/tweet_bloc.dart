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

part 'tweet_event.dart';
part 'tweet_state.dart';

/// Handles actions done on a single tweet, such as retweeting, favoriting,
/// translating, etc.
class TweetBloc extends Bloc<TweetEvent, TweetState> {
  TweetBloc(TweetData tweet) : super(TweetState(tweet: tweet));

  final TweetService tweetService = app<TwitterApi>().tweetService;

  final TranslationService translationService = app<TranslationService>();

  final LanguagePreferences languagePreferences = app<LanguagePreferences>();

  void onCardTap(TweetData tweet) {
    app<HarpyNavigator>().pushRepliesScreen(tweet: tweet);
  }

  void onRepliesTap(TweetData tweet) {
    onCardTap(tweet);
  }

  void onViewMoreActions(BuildContext context, TweetData tweet) {
    showTweetActionsBottomSheet(context, tweet: tweet);
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
  }

  @override
  Stream<TweetState> mapEventToState(
    TweetEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
