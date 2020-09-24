import 'package:harpy/core/preferences/harpy_preferences.dart';
import 'package:harpy/core/service_locator.dart';

class LayoutPreferences {
  final HarpyPreferences harpyPrefs = app<HarpyPreferences>();

  /// Whether a compact layout should be used.
  bool get compactMode => harpyPrefs.getBool('compactMode', false);
  set compactMode(bool value) => harpyPrefs.setBool('compactMode', value);

  /// Sets all layout settings to the default settings.
  void defaultSettings() {
    compactMode = false;
  }
}
