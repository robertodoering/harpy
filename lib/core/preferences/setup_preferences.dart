import 'package:harpy/core/preferences/harpy_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class SetupPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// Whether the currently authenticated user has been through the setup after
  /// their first login.
  bool get performedSetup =>
      harpyPrefs.getBool('performedSetup', false, prefix: true);
  set performedSetup(bool value) =>
      harpyPrefs.setBool('performedSetup', value, prefix: true);
}
