import 'dart:convert';

import 'package:harpy/core/misc/theme.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:harpy/models/application_model.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HarpyPrefs {
  ApplicationModel applicationModel;

  static final Logger _log = Logger("HarpyPrefs");

  SharedPreferences _preferences;

  /// The [_prefix] is used in keys for user specific preferences.
  String get _prefix => applicationModel.twitterSession.userId;

  Future<void> init() async {
    _log.fine("initializing harpy prefs");
    _preferences = await SharedPreferences.getInstance();
  }

  /// Returns the name of the selected [HarpyTheme].
  String get themeName =>
      _preferences.getString("$_prefix.themeName") ?? HarpyTheme.dark().name;

  /// Sets the name of the selected [HarpyTheme].
  set themeName(String themeName) =>
      _preferences.setString("$_prefix.themeName", themeName);

  /// Returns the set of all saved custom [HarpyThemeData].
  Set<HarpyThemeData> get customThemes {
    return _preferences
        .getKeys()
        .where((key) => key.startsWith("theme."))
        .map((key) {
          try {
            // try to parse the custom theme
            return HarpyThemeData.fromJson(
                jsonDecode(_preferences.getString(key)));
          } catch (e) {
            // invalid custom theme, remove it
            _preferences.remove(key);
            return null;
          }
        })
        .where((data) => data != null)
        .toSet();
  }

  /// Saves a custom [HarpyThemeData] into the shared preferences.
  set customTheme(HarpyThemeData harpyThemeData) => _preferences.setString(
      "theme.${harpyThemeData.name}", harpyThemeData.toJson().toString());
}
