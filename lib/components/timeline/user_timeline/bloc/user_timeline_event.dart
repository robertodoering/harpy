import 'dart:async';

import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_bloc.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_event.dart';

/// Updates the tweets for the user timeline.
class UpdateUserTimelineEvent extends UpdateTimelineEvent {
  const UpdateUserTimelineEvent({
    @required this.screenName,
  });

  /// The screen name of the user that is used to load the timeline.
  final String screenName;

  @override
  Future<List<Tweet>> requestTimeline(TimelineBloc bloc) {
    return bloc.timelineService.userTimeline(
      screenName: screenName,
      count: 200,
    );
  }
}

/// Requests more tweets for the user timeline.
class RequestMoreUserTimelineEvent extends RequestMoreTimelineEvent {
  const RequestMoreUserTimelineEvent({
    @required this.screenName,
  });

  /// The screen name of the user that is used to load the timeline.
  final String screenName;

  @override
  Future<List<Tweet>> requestMore(TimelineBloc bloc) async {
    final String maxId = findMaxId(bloc);

    if (maxId != null) {
      return bloc.timelineService.userTimeline(
        screenName: screenName,
        count: 200,
        maxId: maxId,
      );
    } else {
      return null;
    }
  }
}
