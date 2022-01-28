import 'package:harpy/core/core.dart';

class GeneralPreferences {
  const GeneralPreferences();

  /// Whether animations and effects should be reduced to increase
  /// performance on lower end devices.
  bool get performanceMode =>
      app<HarpyPreferences>().getBool('performanceMode', false);
  set performanceMode(bool value) =>
      app<HarpyPreferences>().setBool('performanceMode', value);

  /// Whether the user has consented to send automatic crash reports.
  bool get crashReports =>
      app<HarpyPreferences>().getBool('crashReports', true);
  set crashReports(bool value) =>
      app<HarpyPreferences>().setBool('crashReports', value);

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
      app<HarpyPreferences>().getInt('timelinePositionBehavior', 0);
  set homeTimelinePositionBehavior(int value) =>
      app<HarpyPreferences>().setInt('timelinePositionBehavior', value);

  /// Whether a floating compose button should show in the home screen.
  bool get floatingComposeButton =>
      app<HarpyPreferences>().getBool('floatingComposeButton', false);
  set floatingComposeButton(bool value) =>
      app<HarpyPreferences>().setBool('floatingComposeButton', value);

  bool get keepLastHomeTimelinePosition => homeTimelinePositionBehavior != 2;
  bool get keepNewestReadTweet => homeTimelinePositionBehavior == 0;
  bool get keepLastReadTweet => homeTimelinePositionBehavior == 1;
}
