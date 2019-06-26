import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

/// The [ThemeSettingsModel] descendant sits above the [MaterialApp] and
/// rebuilds the app whenever the [Theme] changes.
class ThemeSettingsModel extends ChangeNotifier {
  ThemeSettingsModel({
    @required this.harpyPrefs,
  });

  final HarpyPrefs harpyPrefs;

  static ThemeSettingsModel of(BuildContext context) {
    return Provider.of<ThemeSettingsModel>(context);
  }

  static final Logger _log = Logger("ThemeSettingsModel");

  /// The selected theme used by the app.
  HarpyTheme harpyTheme = PredefinedThemes.themes.first;

  /// The id of the selected theme.
  int get selectedThemeId =>
      harpyPrefs.getInt("${harpyPrefs.prefix}.selectedThemeId", 0);

  /// Changes the selected theme and rebuilds the app which listens to this
  /// [ThemeSettingsModel].
  void changeSelectedTheme(HarpyTheme theme, int id) async {
    _log.fine("changing selected theme to id: $id");

    harpyTheme = theme;
    harpyPrefs.preferences.setInt("${harpyPrefs.prefix}.selectedThemeId", id);
    notifyListeners();
  }

  /// Returns the list of all saved custom [HarpyThemeData].
  List<HarpyThemeData> getCustomThemes() {
    _log.fine("getting custom themes");

    return harpyPrefs.preferences
            .getStringList("customThemes")
            ?.map(_decodeCustomTheme)
            ?.where((data) => data != null)
            ?.toList() ??
        [];
  }

  /// Saves the list of [customThemes] into the shared preferences.
//  void saveCustomThemes(List<HarpyThemeData> customThemes) {
//    _log.fine("saving custom themes: $customThemes");
//
//    preferences.setStringList(
//      "customThemes",
//      customThemes.map((data) {
//        return jsonEncode(data.toJson());
//      }).toList(),
//    );
//  }

  /// Initializes the [HarpyTheme] with the theme set in [HarpyPrefs].
  ///
  /// Defaults to [HarpyTheme.dark].
  void initTheme() {
    int id = selectedThemeId;

    _log.fine("initializing harpy theme with id $id");

    final predefinedThemes = PredefinedThemes.themes;

    if (id < predefinedThemes.length) {
      harpyTheme = predefinedThemes[id];
    } else {
      // load data from custom theme
      HarpyThemeData customThemeData = _getCustomTheme(id);

      if (customThemeData != null) {
        harpyTheme = HarpyTheme.fromData(customThemeData);
      } else {
        _log.warning("unable to load custom theme for id: $id, defaulting to"
            " dark theme");
        harpyTheme = PredefinedThemes.themes.first;
      }
    }

    notifyListeners();
  }

  /// Returns the [HarpyThemeData] for the [id] of the custom themes list.
  ///
  /// Returns `null` if the id is not in the list.
  HarpyThemeData _getCustomTheme(int id) {
    _log.fine("getting custom harpy theme for id: $id");

    try {
      // subtract the length of predefined themes
      id -= PredefinedThemes.themes.length;

      return getCustomThemes()[id];
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
