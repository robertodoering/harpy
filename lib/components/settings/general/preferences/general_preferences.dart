import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

part 'general_preferences.freezed.dart';

final generalPreferencesProvider =
    StateNotifierProvider<GeneralPreferencesNotifier, GeneralPreferences>(
  (ref) => GeneralPreferencesNotifier(
    preferences: ref.watch(preferencesProvider(null)),
  ),
  name: 'GeneralPreferencesProvider',
);

class GeneralPreferencesNotifier extends StateNotifier<GeneralPreferences> {
  GeneralPreferencesNotifier({
    required Preferences preferences,
  })  : _preferences = preferences,
        super(
          GeneralPreferences(
            performanceMode: preferences.getBool('performanceMode', false),
            crashReports: preferences.getBool('crashReports', true),
            homeTimelinePositionBehavior: preferences.getInt(
              'timelinePositionBehavior',
              0,
            ),
            floatingComposebutton: preferences.getBool(
              'floatingComposeButton',
              false,
            ),
            hideHomeAppBar: preferences.getBool('hideHomeTabBar', true),
            bottomAppBar: preferences.getBool('bottomAppBar', false),
          ),
        );

  final Preferences _preferences;

  void setPerformanceMode(bool value) {
    state = state.copyWith(performanceMode: value);
    _preferences.setBool('performanceMode', value);
  }

  void setCrashReports(bool value) {
    state = state.copyWith(crashReports: value);
    _preferences.setBool('crashReports', value);
  }

  void setHomeTimelinePositionBehavior(int value) {
    state = state.copyWith(homeTimelinePositionBehavior: value);
    _preferences.setInt('timelinePositionBehavior', value);
  }

  void setFloatingComposebutton(bool value) {
    state = state.copyWith(floatingComposebutton: value);
    _preferences.setBool('floatingComposeButton', value);
  }

  void setHideHomeAppbar(bool value) {
    state = state.copyWith(hideHomeAppBar: value);
    _preferences.setBool('hideHomeTabBar', value);
  }

  void setBottomAppBar(bool value) {
    state = state.copyWith(bottomAppBar: value);
    _preferences.setBool('bottomAppBar', value);
  }
}

@freezed
class GeneralPreferences with _$GeneralPreferences {
  factory GeneralPreferences({
    /// Whether animations and effects should be reduced to increase
    /// performance on lower end devices.
    required bool performanceMode,

    /// Whether the user has consented to send automatic crash reports.
    required bool crashReports,

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
    required int homeTimelinePositionBehavior,

    /// Whether a floating compose button should show in the home screen.
    required bool floatingComposebutton,

    /// Whether the home app bar should automatically hide when scrolling.
    required bool hideHomeAppBar,

    /// Whether the app bar should be built at the bottom of the home screen
    /// instead of the top.
    required bool bottomAppBar,
  }) = _GeneralPreferences;

  GeneralPreferences._();

  late final keepLastHomeTimelinePosition = homeTimelinePositionBehavior != 2;
  late final keepNewestReadTweet = homeTimelinePositionBehavior == 0;
  late final keepLastReadTweet = homeTimelinePositionBehavior == 1;
}
