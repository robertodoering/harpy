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
  }) : assert(themeSettingsModel != null) {
    // initialize the custom theme data with the edited theme or the current
    // theme when creating a new theme
    customThemeData =
        HarpyThemeData.fromHarpyTheme(themeSettingsModel.harpyTheme);
    customThemeData.name = "New theme 1";
  }

  final ThemeSettingsModel themeSettingsModel;

  static CustomThemeModel of(BuildContext context) {
    return Provider.of<CustomThemeModel>(context);
  }

  /// The custom theme data that is being customized.
  ///
  /// Initialized with the data from the active theme.
  HarpyThemeData customThemeData;

  /// `true` if the name only contains valid characters.
  bool validName = true;

  /// Returns the error text if an error exists, otherwise `null`.
  String errorText() {
    if (customThemeData.name?.isEmpty ?? true) {
      return null;
    }

    if (!validName) {
      return "Name contains invalid characters";
    }

    return null;
  }

  HarpyTheme get harpyTheme => HarpyTheme.fromData(customThemeData);

  void changeName(String name) {
    customThemeData.name = name;

    // validate name
    validName = _validateName();
  }

  void changePrimaryColor(Color color) {
    customThemeData.primaryColor = color.value;
    notifyListeners();
  }

  void changeAccentColor(Color color) {
    customThemeData.accentColor = color.value;
    notifyListeners();
  }

  void changeBackgroundColors(List<Color> colors) {
    customThemeData.backgroundColors = colors.map((color) => color.value);
    notifyListeners();
  }

  /// Returns `true` if the name only contains alphanumeric characters, '-', '_'
  /// and spaces.
  bool _validateName() {
    return customThemeData.name.contains(RegExp(r"^[-_ a-zA-Z0-9]+$"));
  }
}
