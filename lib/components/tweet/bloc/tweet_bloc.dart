import 'dart:async';

import 'package:dart_twitter_api/api/tweets/tweet_service.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/tweet/bloc/tweet_event.dart';
import 'package:harpy/components/tweet/bloc/tweet_state.dart';
import 'package:harpy/core/api/translate/translate_service.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';

/// Handles actions done on a single tweet, such as retweeting, favoriting,
/// translating, etc.
class TweetBloc extends Bloc<TweetEvent, TweetState> {
  TweetBloc(this.tweet);

  final TweetData tweet;

  final TweetService tweetService = app<TwitterApi>().tweetService;

  final TranslationService translationService = app<TranslationService>();

  static TweetBloc of(BuildContext context) =>
      BlocProvider.of<TweetBloc>(context);

  @override
  TweetState get initialState => InitialState();

  @override
  Stream<TweetState> mapEventToState(
    TweetEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
