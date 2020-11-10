import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/preferences/harpy_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class ChangelogPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();
  final HarpyInfo harpyInfo = app<HarpyInfo>();

  /// Whether the changelog dialog should appear when the app has been updated
  /// to a new version.
  bool get showChangelogDialog =>
      harpyPrefs.getBool('showChangelogDialog', true);
  set showChangelogDialog(bool value) =>
      harpyPrefs.setBool('showChangelogDialog', value);

  /// The version code for the app version the changelog dialog last showed on.
  ///
  /// When the current version code is equal the last shown version code the
  /// dialog should not appear.
  int get lastShownVersion => harpyPrefs.getInt('lastShownVersion', 0);
  set lastShownVersion(int value) =>
      harpyPrefs.setInt('lastShownVersion', value);

  /// Whether the current version code is bigger than the [lastShownVersion].
  bool get shouldShowChangelogDialog =>
      showChangelogDialog &&
      (int.tryParse(harpyInfo.packageInfo.buildNumber) ?? 0) > lastShownVersion;
}
