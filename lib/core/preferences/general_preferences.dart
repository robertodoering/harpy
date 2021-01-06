import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/preferences/harpy_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class GeneralPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();
  final HarpyInfo harpyInfo = app<HarpyInfo>();

  /// Whether animations and effects should be reduced to increase
  /// performance on lower end devices.
  bool get performanceMode => harpyPrefs.getBool('performanceMode', false);
  set performanceMode(bool value) =>
      harpyPrefs.setBool('performanceMode', value);
}
