import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

part 'general_preferences.freezed.dart';

final generalPreferencesProvider =
    StateNotifierProvider<GeneralPreferencesNotifier, GeneralPreferences>(
  (ref) => GeneralPreferencesNotifier(
    preferences: ref.watch(preferencesProvider(null)),
    deviceInfo: ref.watch(deviceInfoProvider),
  ),
  name: 'GeneralPreferencesProvider',
);

class GeneralPreferencesNotifier extends StateNotifier<GeneralPreferences> {
  GeneralPreferencesNotifier({
    required Preferences preferences,
    required DeviceInfo deviceInfo,
  })  : _preferences = preferences,
        _deviceInfo = deviceInfo,
        super(
          GeneralPreferences(
            showChangelogDialog: preferences.getBool(
              'showChangelogDialog',
              true,
            ),
            lastShownVersion: preferences.getInt('lastShownVersion', 0),
            performanceMode: preferences.getBool('performanceMode', false),
            crashReports: preferences.getBool('crashReports', true),
            homeTimelinePositionBehavior: preferences.getInt(
              'timelinePositionBehavior',
              2,
            ),
            floatingComposeButton: preferences.getBool(
              'floatingComposeButton',
              false,
            ),
            homeTimelineRefreshBehavior:
                preferences.getBool('timelineRefreshBehavior', false),
            hideHomeAppBar: preferences.getBool('hideHomeTabBar', true),
            bottomAppBar: preferences.getBool('bottomAppBar', false),
            alwaysUse24HourFormat: preferences.getBool(
              'alwaysUse24HourFormat',
              false,
            ),
          ),
        );

  final Preferences _preferences;
  final DeviceInfo _deviceInfo;

  void defaultSettings() {
    setShowChangelogDialog(true);
    setPerformanceMode(false);
    setCrashReports(true);
    setHomeTimelinePositionBehavior(2);
    setHomeTimelineRefreshBehavior(false);
    setFloatingComposeButton(false);
    setHideHomeAppbar(true);
    setBottomAppBar(false);
    setAlwaysUse24HourFormat(false);
  }

  void setShowChangelogDialog(bool value) {
    state = state.copyWith(showChangelogDialog: value);
    _preferences.setBool('showChangelogDialog', value);
  }

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

  void setHomeTimelineRefreshBehavior(bool value) {
    state = state.copyWith(homeTimelineRefreshBehavior: value);
    _preferences.setBool('timelineRefreshBehavior', value);
  }

  void setFloatingComposeButton(bool value) {
    state = state.copyWith(floatingComposeButton: value);
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

  void setAlwaysUse24HourFormat(bool value) {
    state = state.copyWith(alwaysUse24HourFormat: value);
    _preferences.setBool('alwaysUse24HourFormat', value);
  }

  void updateLastShownVersion() {
    final version = _deviceInfo.packageInfo?.buildNumber;

    if (version != null) {
      final versionInt = int.tryParse(version);

      if (versionInt != null) {
        state = state.copyWith(lastShownVersion: versionInt);
        _preferences.setInt('lastShownVersion', versionInt);
      }
    }
  }
}

@freezed
class GeneralPreferences with _$GeneralPreferences {
  factory GeneralPreferences({
    /// Whether the changelog dialog should appear when the app has been updated
    /// to a new version.
    required bool showChangelogDialog,

    /// The version code for the app version the changelog dialog last showed
    /// on.
    required int lastShownVersion,

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
    required bool floatingComposeButton,

    /// Whether the home timeline should restore its position after refresh.
    required bool homeTimelineRefreshBehavior,

    /// Whether the home app bar should automatically hide when scrolling.
    required bool hideHomeAppBar,

    /// Whether the app bar should be built at the bottom of the home screen
    /// instead of the top.
    required bool bottomAppBar,
    required bool alwaysUse24HourFormat,
  }) = _GeneralPreferences;

  GeneralPreferences._();

  late final keepLastHomeTimelinePosition = homeTimelinePositionBehavior != 2;
  late final keepNewestReadTweet = homeTimelinePositionBehavior == 0;
  late final keepLastReadTweet = homeTimelinePositionBehavior == 1;

  /// Whether the changelog dialog should show.
  ///
  /// - [showChangelogDialog] needs to be true
  /// - [lastShownVersion] must have been set before (not a new user opening
  /// the app for the first time)
  /// - the [lastShownVersion] must be smaller than the current version (user
  /// has updated)
  bool shouldShowChangelogDialog(DeviceInfo deviceInfo) =>
      showChangelogDialog &&
      lastShownVersion != 0 &&
      (int.tryParse(deviceInfo.packageInfo?.buildNumber ?? '0') ?? 0) >
          lastShownVersion;
}
