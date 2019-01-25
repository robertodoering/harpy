import 'package:flutter/material.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:harpy/theme.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';

class ThemeModel extends Model {
  static ThemeModel of(BuildContext context) {
    return ScopedModel.of<ThemeModel>(context);
  }

  static final Logger _log = Logger("ThemeModel");

  HarpyTheme harpyTheme = HarpyTheme.light();

  void updateTheme(HarpyTheme theme) {
    harpyTheme = theme;
    notifyListeners();
  }

  /// Initializes the [HarpyTheme] with the theme set in [HarpyPrefs].
  ///
  /// Defaults to [HarpyTheme.dark].
  void initTheme() {
    _log.fine("initializing harpy theme with ${HarpyPrefs().themeName}");

    if (HarpyPrefs().themeName == HarpyTheme.dark().name) {
      harpyTheme = HarpyTheme.dark();
    } else if (HarpyPrefs().themeName == HarpyTheme.light().name) {
      harpyTheme = HarpyTheme.light();
    } else {
      _log.severe("custom theme not yet supported, panic");
      // load harpyThemeData for custom theme
    }

    notifyListeners();
  }
}
