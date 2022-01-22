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
}
