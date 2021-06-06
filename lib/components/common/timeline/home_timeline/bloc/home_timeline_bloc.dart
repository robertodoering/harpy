import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/api/tweets/timeline_service.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'home_timeline_event.dart';
part 'home_timeline_state.dart';

class HomeTimelineBloc extends Bloc<HomeTimelineEvent, HomeTimelineState>
    with RequestLock {
  HomeTimelineBloc() : super(const HomeTimelineInitial());

  final TimelineService timelineService = app<TwitterApi>().timelineService;
  final TweetVisibilityPreferences tweetVisibilityPreferences =
      app<TweetVisibilityPreferences>();
  final TimelineFilterPreferences timelineFilterPreferences =
      app<TimelineFilterPreferences>();

  /// Completes when the home timeline has been refreshed using the
  /// [RefreshHomeTimeline] event.
  Completer<void> refreshCompleter = Completer<void>();

  /// Completes when older tweets for the timeline have been requested using
  /// [RequestOlderHomeTimeline].
  Completer<void> requestOlderCompleter = Completer<void>();

  @override
  Stream<HomeTimelineState> mapEventToState(
    HomeTimelineEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
