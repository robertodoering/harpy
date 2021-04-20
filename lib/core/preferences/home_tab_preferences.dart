import 'package:harpy/core/core.dart';

class HomeTabPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// The json encoded string for the home tab bar configuration.
  String get homeTabEntries =>
      harpyPrefs.getString('homeTabEntries', '', prefix: true);
  set homeTabEntries(String value) =>
      harpyPrefs.setString('homeTabEntries', value, prefix: true);
}
