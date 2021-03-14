import 'package:flutter/material.dart';
import 'package:harpy/components/timeline/filter/model/timeline_filter.dart';
import 'package:harpy/components/timeline/likes_timeline/widgets/likes_timeline.dart';
import 'package:harpy/core/preferences/timeline_filter_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class UserLikesTimeline extends StatelessWidget {
  const UserLikesTimeline();

  @override
  Widget build(BuildContext context) {
    final TimelineFilter timelineFilter = TimelineFilter.fromJsonString(
      app<TimelineFilterPreferences>().userTimelineFilter,
    );

    return LikesTimeline(timelineFilter: timelineFilter);
  }
}
