import 'package:flutter/foundation.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_bloc.dart';
import 'package:harpy/components/timeline/user_timeline/bloc/user_timeline_event.dart';

class UserTimelineBloc extends TimelineBloc {
  UserTimelineBloc({
    @required this.screenName,
  }) {
    add(UpdateUserTimelineEvent(screenName: screenName));
  }

  /// The screen name of the user that is used to load the timeline.
  final String screenName;
}
