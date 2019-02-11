import 'package:flutter/material.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';

/// The [ThemeModel] sits above the [MaterialApp] and rebuilds the app whenever
/// the [Theme] changes.
class ThemeModel extends Model {
  ThemeModel({
    @required this.harpyPrefs,
  });

  final HarpyPrefs harpyPrefs;

  static ThemeModel of(BuildContext context) {
    return ScopedModel.of<ThemeModel>(context);
  }

  static final Logger _log = Logger("ThemeModel");

  /// The selected theme used by the app.
  HarpyTheme harpyTheme = HarpyTheme.light();

  /// Changes the selected theme and rebuilds the app which listens to this
  /// [ThemeModel].
  void changeSelectedTheme(HarpyTheme theme, int id) async {
    _log.fine("changing selected theme to id: $id");

    harpyTheme = theme;
    harpyPrefs.setSelectedThemeId(id);
    notifyListeners();
  }

  /// Whether or not the theme with the [id] is the currently selected Theme.
  bool selectedTheme(int id) {
    return harpyPrefs.getSelectedThemeId() == id;
  }

  /// Initializes the [HarpyTheme] with the theme set in [HarpyPrefs].
  ///
  /// Defaults to [HarpyTheme.dark].
  void initTheme() {
    int id = harpyPrefs.getSelectedThemeId();

    _log.fine("initializing harpy theme with id ${id}");

    if (id == 0) {
      harpyTheme = HarpyTheme.light();
    } else if (id == 1) {
      harpyTheme = HarpyTheme.dark();
    } else {
      // load harpyThemeData for custom theme
      HarpyThemeData customThemeData = harpyPrefs.getCustomTheme(id);

      if (customThemeData != null) {
        harpyTheme = HarpyTheme.custom(customThemeData);
      } else {
        _log.warning(
            "unable to load custom theme for id: $id, defaulting to dark theme");
        harpyTheme = HarpyTheme.dark();
      }
    }

    notifyListeners();
  }
}
