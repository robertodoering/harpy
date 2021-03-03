import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/api/tweets/timeline_service.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/timeline/filter/model/timeline_filter.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/request_lock_mixin.dart';
import 'package:harpy/core/api/twitter/handle_tweets.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/logger_mixin.dart';
import 'package:harpy/core/preferences/timeline_filter_preferences.dart';
import 'package:harpy/core/service_locator.dart';

part 'user_timeline_event.dart';
part 'user_timeline_state.dart';

class UserTimelineBloc extends Bloc<UserTimelineEvent, UserTimelineState>
    with RequestLock {
  UserTimelineBloc({
    @required this.screenName,
  }) : super(const UserTimelineInitial());

  final String screenName;

  final TimelineService timelineService = app<TwitterApi>().timelineService;
  final TimelineFilterPreferences timelineFilterPreferences =
      app<TimelineFilterPreferences>();

  /// Completes when the user timeline has been requested using the
  /// [RequestUserTimeline] event.
  Completer<void> requestTimelineCompleter = Completer<void>();

  /// Completes when older tweets for the timeline have been requested using
  /// [RequestOlderUserTimeline].
  Completer<void> requestOlderCompleter = Completer<void>();

  @override
  Stream<UserTimelineState> mapEventToState(
    UserTimelineEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
