import 'package:flutter/material.dart';
import 'package:harpy/core/misc/theme.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';

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
  void updateTheme(HarpyTheme theme) {
    harpyTheme = theme;
    harpyPrefs.themeName = theme.name;
    notifyListeners();
  }

  /// Initializes the [HarpyTheme] with the theme set in [HarpyPrefs].
  ///
  /// Defaults to [HarpyTheme.dark].
  void initTheme() {
    _log.fine("initializing harpy theme with ${harpyPrefs.themeName}");

    if (harpyPrefs.themeName == HarpyTheme.dark().name) {
      harpyTheme = HarpyTheme.dark();
    } else if (harpyPrefs.themeName == HarpyTheme.light().name) {
      harpyTheme = HarpyTheme.light();
    } else {
      _log.severe("custom theme not yet supported, panic");
      // load harpyThemeData for custom theme
    }

    notifyListeners();
  }
}
