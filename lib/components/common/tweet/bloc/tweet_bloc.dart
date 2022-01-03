import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:http/http.dart';

part 'tweet_bloc.freezed.dart';
part 'tweet_bloc_action_mixin.dart';
part 'tweet_event.dart';

/// Handles actions done on a single tweet, such as retweeting, favoriting,
/// translating, etc.
///
/// Delegates used in the presentation are methods on the bloc to allow for the
/// [PreviewTweetBloc] to change their implementation.
class TweetBloc extends Bloc<TweetEvent, TweetState>
    with TweetBlocActionCallback {
  TweetBloc(this.tweet)
      : super(
          TweetState(
            retweeted: tweet.retweeted,
            favorited: tweet.favorited,
            translated: tweet.hasTranslation,
            isTranslating: false,
          ),
        ) {
    on<TweetEvent>(
      (event, emit) => event.handle(this, emit),
      transformer: sequential(),
    );
  }

  /// The tweet that is used to display a tweet card.
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
      initialUser: tweet.user,
    );
  }

  void onRetweeterTap(BuildContext context) {
    final route = ModalRoute.of(context);

    assert(route != null);
    assert(tweet.retweetUserHandle != null);

    if (tweet.retweetUserHandle != null) {
      app<HarpyNavigator>().pushUserProfile(
        currentRoute: route?.settings,
        handle: tweet.retweetUserHandle,
      );
    }
  }

  void onViewMoreActions(BuildContext context) {
    showTweetActionsBottomSheet(context, tweet: tweet);
  }

  void onToggleRetweet() {
    HapticFeedback.lightImpact();
    if (state.retweeted) {
      add(const TweetEvent.unretweet());
    } else {
      add(const TweetEvent.retweet());
    }
  }

  void onUnretweet() {
    HapticFeedback.lightImpact();
    add(const TweetEvent.unretweet());
  }

  void onComposeQuote() {
    app<HarpyNavigator>().pushComposeScreen(quotedTweet: tweet);
  }

  void onShowRetweeters() {
    app<HarpyNavigator>().pushRetweetersScreen(
      tweetId: tweet.id,
    );
  }

  void onFavorite() {
    HapticFeedback.lightImpact();
    add(const TweetEvent.favorite());
  }

  void onUnfavorite() {
    HapticFeedback.lightImpact();
    add(const TweetEvent.unfavorite());
  }

  void onTranslate(Locale locale) {
    HapticFeedback.lightImpact();
    add(TweetEvent.translate(locale: locale));

    _invoke(TweetAction.translate);
  }

  void onReplyToTweet() {
    app<HarpyNavigator>().pushComposeScreen(inReplyToStatus: tweet);
  }
}

/// Mirrors state of the mutable [TweetBloc.tweet], which the presentation uses
/// to update its content.
///
/// Ideally the [TweetData] would be the state, however since it's mutable we
/// wrap the necessary values in this state.
@freezed
class TweetState with _$TweetState {
  const factory TweetState({
    required bool retweeted,
    required bool favorited,
    required bool translated,
    required bool isTranslating,
  }) = _State;
}
