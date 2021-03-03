import 'package:harpy/core/preferences/harpy_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class TimelineFilterPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// The json encoded string for the home timeline filter.
  String get homeTimelineFilter =>
      harpyPrefs.getString('homeTimelineFilter', '', prefix: true);
  set homeTimelineFilter(String value) =>
      harpyPrefs.setString('homeTimelineFilter', value, prefix: true);

  /// The json encoded string for the user timeline filter.
  String get userTimelineFilter =>
      harpyPrefs.getString('userTimelineFilter', '', prefix: true);
  set userTimelineFilter(String value) =>
      harpyPrefs.setString('userTimelineFilter', value, prefix: true);
}
