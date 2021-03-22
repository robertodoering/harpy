import 'package:harpy/core/core.dart';

class GeneralPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();
  final HarpyInfo harpyInfo = app<HarpyInfo>();

  /// Whether animations and effects should be reduced to increase
  /// performance on lower end devices.
  bool get performanceMode => harpyPrefs.getBool('performanceMode', false);
  set performanceMode(bool value) =>
      harpyPrefs.setBool('performanceMode', value);
}
