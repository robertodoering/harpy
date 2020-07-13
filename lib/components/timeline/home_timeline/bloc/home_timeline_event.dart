import 'dart:async';

import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_bloc.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_event.dart';

class UpdateHomeTimelineEvent extends UpdateTimelineEvent {
  @override
  Future<List<Tweet>> requestTimeline(TimelineBloc bloc) {
    return bloc.timelineService.homeTimeline(count: 200);
  }
}
