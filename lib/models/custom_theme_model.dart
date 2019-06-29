import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:provider/provider.dart';

/// The model for creating or editing a custom theme.
class CustomThemeModel extends ChangeNotifier {
  CustomThemeModel({
    @required this.themeSettingsModel,
    this.editingThemeData,
    this.editingThemeId,
  }) : assert(themeSettingsModel != null) {
    if (editingTheme) {
      // initialize the custom theme with the edited theme.
      customThemeData = editingThemeData;
    } else {
      // initialize the custom theme with the current theme and a template name.
      customThemeData =
          HarpyThemeData.fromHarpyTheme(themeSettingsModel.harpyTheme);
      customThemeData.name =
          "New theme ${themeSettingsModel.customThemes.length + 1}";
    }
  }

  final ThemeSettingsModel themeSettingsModel;

  static CustomThemeModel of(BuildContext context) {
    return Provider.of<CustomThemeModel>(context);
  }

  /// The custom theme data that is being customized.
  ///
  /// Initialized with the data from the active theme.
  HarpyThemeData customThemeData;

  /// The theme to edit.
  final HarpyThemeData editingThemeData;

  /// The id of the custom theme if one is being edited.
  final int editingThemeId;

  /// Returns true if a theme is being edited.
  bool get editingTheme => editingThemeId != null && editingThemeData != null;

  /// `true` if the name only contains valid characters.
  bool validName = true;

  /// `true` of a different custom theme already exists with the same name.
  bool existingName = false;

  /// Returns the error text if an error exists, otherwise `null`.
  String errorText() {
    if (customThemeData.name?.isEmpty ?? true) {
      return null;
    }

    if (!validName) {
      return "Name contains invalid characters";
    }

    if (existingName) {
      return "Theme with name ${customThemeData.name} already exists";
    }

    return null;
  }

  HarpyTheme get harpyTheme => HarpyTheme.fromData(customThemeData);

  void changeName(String name) {
    customThemeData.name = name;

    // validate name
    validName = _validateName();
    existingName = _existingName();
  }

  void changePrimaryColor(Color color) {
    customThemeData.primaryColor = color.value;
    notifyListeners();
  }

  void changeAccentColor(Color color) {
    customThemeData.accentColor = color.value;
    notifyListeners();
  }

  void changeFirstBackgroundColor(Color color) {
    customThemeData.backgroundColors.first = color.value;
    notifyListeners();
  }

  void changeSecondBackgroundColor(Color color) {
    customThemeData.backgroundColors.last = color.value;
    notifyListeners();
  }

  /// Returns `true` if the name only contains alphanumeric characters, '-', '_'
  /// and spaces.
  bool _validateName() {
    return customThemeData.name.contains(RegExp(r"^[-_ a-zA-Z0-9]+$"));
  }

  /// Returns `true` if the name already exists in the saved custom themes.
  bool _existingName() {
    // return false if it is the edited theme
    if (editingTheme) {
      if (customThemeData.name == editingThemeData.name) {
        return false;
      }
    }

    return themeSettingsModel.customThemes.any((data) {
      return data.name == customThemeData.name;
    });
  }
}
