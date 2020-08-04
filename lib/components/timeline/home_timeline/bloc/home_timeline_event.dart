import 'dart:async';

import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_bloc.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_event.dart';

/// Updates the tweets for the home timeline.
class UpdateHomeTimelineEvent extends UpdateTimelineEvent {
  const UpdateHomeTimelineEvent();

  @override
  Future<List<Tweet>> requestTimeline(TimelineBloc bloc) {
    return bloc.timelineService.homeTimeline(count: 200);
  }
}

/// Requests more tweets for the home timeline.
class RequestMoreHomeTimelineEvent extends RequestMoreTimelineEvent {
  const RequestMoreHomeTimelineEvent();

  @override
  Future<List<Tweet>> requestMore(TimelineBloc bloc) async {
    final String maxId = findMaxId(bloc);

    if (maxId != null) {
      return bloc.timelineService.homeTimeline(
        count: 200,
        maxId: maxId,
      );
    } else {
      return null;
    }
  }
}
