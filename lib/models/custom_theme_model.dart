import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/core/misc/flushbar_service.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:harpy/harpy.dart';
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
      customThemeData = HarpyThemeData.fromHarpyTheme(
        themeSettingsModel.harpyTheme,
      )..name = "New theme ${themeSettingsModel.customThemes.length + 1}";
    }
  }

  final FlushbarService flushbarService = app<FlushbarService>();

  final ThemeSettingsModel themeSettingsModel;

  /// The theme to edit.
  final HarpyThemeData editingThemeData;

  /// The id of the custom theme if one is being edited.
  final int editingThemeId;

  static CustomThemeModel of(BuildContext context) {
    return Provider.of<CustomThemeModel>(context);
  }

  /// The custom theme data that is being customized.
  ///
  /// Initialized with the data from the active theme.
  HarpyThemeData customThemeData;

  /// Returns true if a theme is being edited.
  bool get editingTheme => editingThemeId != null && editingThemeData != null;

  /// Gets the custom theme as a [HarpyTheme].
  HarpyTheme get harpyTheme => HarpyTheme.fromData(customThemeData);

  /// Returns the error text if an error exists, otherwise `null`.
  String errorText() {
    if (customThemeData.name?.isEmpty ?? true) {
      return "Name can't be empty";
    }

    if (!_validateName()) {
      return "Name contains invalid characters";
    }

    if (_existingName()) {
      return "Theme with name ${customThemeData.name} already exists";
    }

    return null;
  }

  /// Returns `true` and saves the new custom theme or returns `false` and shows
  /// an error if the custom theme has an invalid name.
  bool saveTheme() {
    final text = errorText();

    if (text != null) {
      flushbarService.error(text);
      return false;
    }

    if (editingTheme) {
      // edited theme
      themeSettingsModel.updateCustomTheme(
        customThemeData,
        editingThemeId,
      );
    } else {
      // new theme
      themeSettingsModel.saveNewCustomTheme(customThemeData);
    }

    return true;
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

    final brightness = ThemeData.estimateBrightnessForColor(color);

    // change the color of the navigation bar to be the same as the second
    // background color and use an icon brightness that is the opposite of
    // the color's brightness
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color,
      systemNavigationBarIconBrightness:
          brightness == Brightness.light ? Brightness.dark : Brightness.light,
    ));
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

    return PredefinedThemes.data
        .followedBy(themeSettingsModel.customThemes)
        .any((data) {
      return data.name == customThemeData.name;
    });
  }
}
