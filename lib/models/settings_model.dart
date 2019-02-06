import 'package:flutter/material.dart';
import 'package:harpy/core/shared_preferences/harpy_prefs.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingsModel extends Model {
  SettingsModel({
    @required this.harpyPrefs,
  }) : assert(harpyPrefs != null);

  final HarpyPrefs harpyPrefs;

  static SettingsModel of(BuildContext context) {
    return ScopedModel.of<SettingsModel>(context);
  }

  static final Logger _log = Logger("SettingsModel");

  Set<HarpyThemeData> customThemes;

  void loadCustomThemes() {
    _log.fine("loading custom themes");
    customThemes = harpyPrefs.getCustomThemes();
    _log.fine("found ${customThemes?.length} themes");
  }

  /// Saves a custom theme into the shared preferences.
  ///
  /// If a custom theme with the same [HarpyThemeData.name] already exists and
  /// [override] is true it will be overridden.
  ///
  /// Returns `true` when successfully saved, `false` if a custom theme with the
  /// same name already exists and [override] is false.
  bool saveCustomTheme(HarpyThemeData harpyThemeData, bool override) {
    _log.fine("saving custom theme");

    bool alreadyExists = customThemes.any((themeData) {
      return themeData.name == harpyThemeData.name;
    });

    // save the new custom theme if override is true or it doesn't exist already
    if (override || !alreadyExists) {
      customThemes.add(harpyThemeData);
      harpyPrefs.saveCustomTheme(harpyThemeData);
      _log.fine("custom theme saved");
      return true;
    }

    _log.warning("custom theme not saved");
    return false;
  }
}
