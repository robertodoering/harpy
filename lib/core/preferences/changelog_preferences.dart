import 'package:harpy/core/core.dart';

class ChangelogPreferences {
  const ChangelogPreferences();

  /// Whether the changelog dialog should appear when the app has been updated
  /// to a new version.
  bool get showChangelogDialog =>
      app<HarpyPreferences>().getBool('showChangelogDialog', true);
  set showChangelogDialog(bool value) =>
      app<HarpyPreferences>().setBool('showChangelogDialog', value);

  /// The version code for the app version the changelog dialog last showed on.
  ///
  /// When the current version code is equal the last shown version code the
  /// dialog should not appear.
  int get lastShownVersion =>
      app<HarpyPreferences>().getInt('lastShownVersion', 0);
  set lastShownVersion(int value) =>
      app<HarpyPreferences>().setInt('lastShownVersion', value);

  /// Sets the [lastShownVersion] to the current version.
  void setToCurrentShownVersion() {
    lastShownVersion =
        int.tryParse(app<HarpyInfo>().packageInfo?.buildNumber ?? '0') ?? 0;
  }

  /// Whether the changelog dialog should show.
  ///
  /// - [showChangelogDialog] needs to be true
  /// - [lastShownVersion] must have been set before (not a new user opening
  /// the app for the first time)
  /// - the [lastShownVersion] must be smaller than the current version (user
  /// has updated)
  bool get shouldShowChangelogDialog =>
      showChangelogDialog &&
      lastShownVersion != 0 &&
      (int.tryParse(app<HarpyInfo>().packageInfo?.buildNumber ?? '0') ?? 0) >
          lastShownVersion;
}
