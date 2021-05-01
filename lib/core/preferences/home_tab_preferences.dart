import 'package:harpy/core/core.dart';

class HomeTabPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// The json encoded string for the home tab bar configuration.
  String get homeTabConfiguration =>
      harpyPrefs.getString('homeTabConfiguration', '', prefix: true);
  set homeTabConfiguration(String value) =>
      harpyPrefs.setString('homeTabConfiguration', value, prefix: true);
}
