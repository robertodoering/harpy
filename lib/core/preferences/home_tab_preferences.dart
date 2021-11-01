import 'package:harpy/core/core.dart';

class HomeTabPreferences {
  const HomeTabPreferences();

  /// The json encoded string for the home tab bar configuration.
  String get homeTabConfiguration => app<HarpyPreferences>()
      .getString('homeTabConfiguration', '', prefix: true);
  set homeTabConfiguration(String value) => app<HarpyPreferences>()
      .setString('homeTabConfiguration', value, prefix: true);
}
