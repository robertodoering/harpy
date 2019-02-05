import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/core/misc/theme.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:harpy/models/theme_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomThemeModel extends Model {
  CustomThemeModel({
    @required this.themeModel,
  }) : assert(themeModel != null) {
    customThemeData = HarpyThemeData.fromTheme(themeModel.harpyTheme);
  }

  final ThemeModel themeModel;

  static CustomThemeModel of(BuildContext context) {
    return ScopedModel.of<CustomThemeModel>(context);
  }

  HarpyThemeData customThemeData;

  ThemeData get customTheme => HarpyTheme.custom(customThemeData).theme;

  int get initialTabControllerIndex => customThemeData.base == "light" ? 0 : 1;

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
}
