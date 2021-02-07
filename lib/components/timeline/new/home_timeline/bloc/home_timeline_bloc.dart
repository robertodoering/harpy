import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/api/tweets/timeline_service.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/twitter/handle_tweets.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/logger_mixin.dart';
import 'package:harpy/core/preferences/tweet_visibility_preferences.dart';
import 'package:harpy/core/service_locator.dart';

part 'home_timeline_event.dart';
part 'home_timeline_state.dart';

class NewHomeTimelineBloc extends Bloc<HomeTimelineEvent, HomeTimelineState> {
  NewHomeTimelineBloc() : super(const HomeTimelineInitial()) {
    add(const RequestInitialHomeTimeline());
  }

  final TimelineService timelineService = app<TwitterApi>().timelineService;
  final TweetVisibilityPreferences tweetVisibilityPreferences =
      app<TweetVisibilityPreferences>();

  @override
  Stream<HomeTimelineState> mapEventToState(
    HomeTimelineEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
