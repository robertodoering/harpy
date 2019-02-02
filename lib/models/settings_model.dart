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
    customThemes = harpyPrefs.customThemes;
    _log.fine("found ${customThemes?.length} themes");
  }

  /// Saves a custom theme into the shared preferences.
  ///
  /// If a custom theme with the same [HarpyThemeData.name] already exists it
  /// will be overridden.
  void saveCustomTheme(HarpyThemeData harpyThemeData) {}
}
