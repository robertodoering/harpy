import 'dart:convert';

import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:harpy/models/application_model.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HarpyPrefs {
  static final Logger _log = Logger("HarpyPrefs");

  ApplicationModel applicationModel;

  SharedPreferences preferences;

  /// The [_prefix] is used in keys for user specific preferences.
  String get _prefix => applicationModel.twitterSession.userId;

  Future<void> init() async {
    _log.fine("initializing harpy prefs");
    preferences = await SharedPreferences.getInstance();
  }

  /// Returns the id of the selected [HarpyTheme].
  ///
  /// Returns `1` if no theme has been selected before.
  int getSelectedThemeId() =>
      preferences.getInt("$_prefix.selectedThemeId") ?? 1;

  /// Sets the id of the selected [HarpyTheme].
  void setSelectedThemeId(int id) =>
      preferences.setInt("$_prefix.selectedThemeId", id);

  /// Returns the list of all saved custom [HarpyThemeData].
  List<HarpyThemeData> getCustomThemes() {
    _log.fine("getting custom themes");

    return preferences
            .getStringList("customThemes")
            ?.map(_decodeCustomTheme)
            ?.where((data) => data != null)
            ?.toList() ??
        [];
  }

  /// Saves the list of [customThemes] into the shared preferences.
  void saveCustomThemes(List<HarpyThemeData> customThemes) {
    _log.fine("saving custom themes: $customThemes");

    preferences.setStringList(
      "customThemes",
      customThemes.map((data) {
        return jsonEncode(data.toJson());
      }).toList(),
    );
  }

  /// Returns the [HarpyThemeData] for the [id] of the custom themes list.
  ///
  /// Returns `null` if the id is not in the list.
  HarpyThemeData getCustomTheme(int id) {
    _log.fine("getting custom harpy theme for id: $id");

    try {
      return getCustomThemes()[id - 2];
    } catch (e) {
      return null;
    }
  }

  /// Returns the [HarpyThemeData] from the [json] string or `null` if it can't
  /// be parsed.
  HarpyThemeData _decodeCustomTheme(String json) {
    try {
      // try to parse the custom theme
      return HarpyThemeData.fromJson(jsonDecode(json));
    } catch (e) {
      _log.warning("unable to parse theme: $json");
      return null;
    }
  }
}
