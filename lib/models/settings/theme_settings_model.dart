import 'package:flutter/material.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';

/// The [ThemeSettingsModel] descendant sits above the [MaterialApp] and
/// rebuilds the app whenever the [Theme] changes.
class ThemeSettingsModel extends Model {
  ThemeSettingsModel({
    @required this.harpyPrefs,
  });

  final HarpyPrefs harpyPrefs;

  static ThemeSettingsModel of(BuildContext context) {
    return ScopedModel.of<ThemeSettingsModel>(context);
  }

  static final Logger _log = Logger("ThemeModel");

  /// The selected theme used by the app.
  HarpyTheme harpyTheme = HarpyTheme.light();

  /// The id of the selected theme.
  ///
  /// `0` and `1` corresponds to the default light and default dark theme while
  /// higher ids correspond to the index of the custom themes.
  int get selectedThemeId =>
      harpyPrefs.getInt("${harpyPrefs.prefix}.selectedThemeId", 1);

  /// Changes the selected theme and rebuilds the app which listens to this
  /// [ThemeSettingsModel].
  void changeSelectedTheme(HarpyTheme theme, int id) async {
    _log.fine("changing selected theme to id: $id");

    harpyTheme = theme;
    harpyPrefs.preferences.setInt("${harpyPrefs.prefix}.selectedThemeId", id);
    notifyListeners();
  }

  /// Initializes the [HarpyTheme] with the theme set in [HarpyPrefs].
  ///
  /// Defaults to [HarpyTheme.dark].
  void initTheme() {
    int id = selectedThemeId;

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
