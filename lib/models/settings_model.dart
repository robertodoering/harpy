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

  List<HarpyThemeData> customThemes = [];

  void loadCustomThemes() {
    _log.fine("loading custom themes");
    customThemes = harpyPrefs.getCustomThemes();
    _log.fine("found ${customThemes?.length} themes");
  }

  bool selectedTheme(int id) {
    return harpyPrefs.getSelectedThemeId() == id;
  }

  /// Saves a new custom theme into the shared preferences.
  void saveNewCustomTheme(HarpyThemeData harpyThemeData) {
    _log.fine("saving custom theme");

    customThemes.add(harpyThemeData);
    harpyPrefs.saveCustomThemes(customThemes);
    notifyListeners();
    _log.fine("custom theme saved");
  }

  void updateCustomTheme(HarpyThemeData harpyThemeData, int id) {
    _log.fine("updating custom theme");

    customThemes[id - 2] = harpyThemeData;
    harpyPrefs.saveCustomThemes(customThemes);
    notifyListeners();
    _log.fine("custom theme updated");
  }

  /// Deletes a theme associated to its [id] (index of the list saved in shared
  /// preferences).
  void deleteCustomTheme(int id) {
    _log.fine("deleting custom theme with id: $id");

    try {
      customThemes.removeAt(id);
      harpyPrefs.saveCustomThemes(customThemes);
      notifyListeners();
    } catch (e) {
      _log.severe("unable to delete theme at id: $id");
      _log.severe(e.toString());
    }
  }
}
