import 'package:harpy/core/core.dart';

class GeneralPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// Whether animations and effects should be reduced to increase
  /// performance on lower end devices.
  bool get performanceMode => harpyPrefs.getBool('performanceMode', false);
  set performanceMode(bool value) =>
      harpyPrefs.setBool('performanceMode', value);

  /// Whether the user has consented to send automatic crash reports.
  bool get crashReports => harpyPrefs.getBool('crashReports', true);
  set crashReports(bool value) => harpyPrefs.setBool('crashReports', value);

  /// Whether to automatically hide the home tab bar when swiping up / down.
  bool get hideHomeTabBar => harpyPrefs.getBool('hideHomeTabBar', true);
  set hideHomeTabBar(bool value) => harpyPrefs.setBool('hideHomeTabBar', value);

  /// How the home timeline scroll position should behave after the initial
  /// request.
  ///
  /// 0: Show newest read tweet
  ///    The newest tweet that the user has already read in their last session
  ///    should appear initially
  /// 1: Show last read tweet
  ///    The last tweet a user has read in their last session should appear
  ///    initially
  /// 2: Show newest tweet
  ///    Don't change the scroll position
  int get homeTimelinePositionBehavior =>
      harpyPrefs.getInt('timelinePositionBehavior', 0);
  set homeTimelinePositionBehavior(int value) =>
      harpyPrefs.setInt('timelinePositionBehavior', value);

  bool get keepLastHomeTimelinePosition => homeTimelinePositionBehavior != 2;
  bool get keepNewestReadTweet => homeTimelinePositionBehavior == 0;
  bool get keepLastReadTweet => homeTimelinePositionBehavior == 1;
}
