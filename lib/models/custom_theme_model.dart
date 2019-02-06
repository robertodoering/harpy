import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/core/misc/theme.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:harpy/models/settings_model.dart';
import 'package:harpy/models/theme_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomThemeModel extends Model {
  CustomThemeModel({
    @required this.themeModel,
    @required this.settingsModel,
  })  : assert(themeModel != null),
        assert(settingsModel != null) {
    customThemeData = HarpyThemeData.fromTheme(themeModel.harpyTheme);
  }

  final ThemeModel themeModel;
  final SettingsModel settingsModel;

  static CustomThemeModel of(BuildContext context) {
    return ScopedModel.of<CustomThemeModel>(context);
  }

  HarpyThemeData customThemeData;

  /// `true` if the name only contains valid characters.
  bool validName = true;

  /// `true` if a custom theme with the name already exists.
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

  ThemeData get customTheme => HarpyTheme.custom(customThemeData).theme;

  int get initialTabControllerIndex => customThemeData.base == "light" ? 0 : 1;

  void changeName(String name) {
    customThemeData.name = name;

    // validate name
    validName = _validateName();
    existingName = _existingName();
  }

  void changeBase(int index) {
    customThemeData.base = index == 0 ? "light" : "dark";
    notifyListeners();
  }

  void changePrimaryColor(Color color) {
    customThemeData.primaryColor = color.value;
    notifyListeners();
  }

  void changeAccentColor(Color color) {
    customThemeData.accentColor = color.value;
    notifyListeners();
  }

  void changeBackgroundColor(Color color) {
    customThemeData.scaffoldBackgroundValue = color.value;
    notifyListeners();
  }

  /// Returns `true` if the name only contains alphanumeric characters, '-', '_'
  /// and spaces.
  bool _validateName() {
    return customThemeData.name.contains(RegExp(r"^[-_ a-zA-Z0-9]+$"));
  }

  /// Returns `true` if the name already exists in the saved custom themes.
  bool _existingName() {
    return settingsModel.customThemes.any((customTheme) {
      return customTheme.name == customThemeData.name;
    });
  }
}
