import 'package:harpy/core/core.dart';

class TimelineFilterPreferences {
  const TimelineFilterPreferences();

  /// The json encoded string for the home timeline filter.
  String get homeTimelineFilter =>
      app<HarpyPreferences>().getString('homeTimelineFilter', '', prefix: true);
  set homeTimelineFilter(String value) => app<HarpyPreferences>()
      .setString('homeTimelineFilter', value, prefix: true);

  /// The json encoded string for the user timeline filter.
  String get userTimelineFilter =>
      app<HarpyPreferences>().getString('userTimelineFilter', '', prefix: true);
  set userTimelineFilter(String value) => app<HarpyPreferences>()
      .setString('userTimelineFilter', value, prefix: true);

  /// The json encoded string for the list timeline filter.
  String get listTimelineFilter =>
      app<HarpyPreferences>().getString('listTimelineFilter', '', prefix: true);
  set listTimelineFilter(String value) => app<HarpyPreferences>()
      .setString('listTimelineFilter', value, prefix: true);
}
