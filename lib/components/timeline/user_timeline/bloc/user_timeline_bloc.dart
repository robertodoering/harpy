import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/api/tweets/timeline_service.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/core/preferences/timeline_filter_preferences.dart';
import 'package:harpy/core/service_locator.dart';

part 'user_timeline_event.dart';
part 'user_timeline_state.dart';

class UserTimelineBloc extends Bloc<UserTimelineEvent, UserTimelineState> {
  UserTimelineBloc() : super(const UserTimelineInitial());

  final TimelineService timelineService = app<TwitterApi>().timelineService;
  final TimelineFilterPreferences timelineFilterPreferences =
      app<TimelineFilterPreferences>();

  @override
  Stream<UserTimelineState> mapEventToState(
    UserTimelineEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
