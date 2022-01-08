import 'package:harpy/core/core.dart';

class TimelineFilterPreferences {
  const TimelineFilterPreferences();

  List<String> get timelineFilters =>
      app<HarpyPreferences>().getStringList('timelineFilters');
  set timelineFilters(List<String> value) =>
      app<HarpyPreferences>().setStringList('timelineFilters', value);

  List<String> get activeTimelineFilters =>
      app<HarpyPreferences>().getStringList('activeTimelineFilters');
  set activeTimelineFilters(List<String> value) =>
      app<HarpyPreferences>().setStringList('activeTimelineFilters', value);

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
