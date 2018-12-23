import 'package:flutter/material.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';

class HarpyTheme {
  static HarpyTheme instance;

  HarpyTheme.light() {
    _theme = ThemeData.light();
    _textTheme = ThemeData.light().textTheme.apply(fontFamily: "OpenSans");
    primaryColor = Colors.indigo;
    accentColor = Colors.indigoAccent;
    buttonColor = Colors.white;
  }

  HarpyTheme.dark() {
    _theme = ThemeData.dark();
    _textTheme = ThemeData.dark().textTheme.apply(fontFamily: "OpenSans");
//    primaryColor = Colors.indigo;
    accentColor = Colors.indigoAccent;
    buttonColor = Colors.white;
  }

  HarpyTheme.custom(HarpyThemeData harpyThemeData) {
    // todo
    primaryColor = Color(harpyThemeData.primaryColor);
    accentColor = Color(harpyThemeData.accentColor);
  }

  factory HarpyTheme() => instance;

  /// The color that will be drawn in the splash screen and [LoginScreen].
  static const Color harpyColor = Colors.indigo;

  ThemeData _theme;
  TextTheme _textTheme;

  Color primaryColor;
  Color accentColor;
  Color buttonColor;

  ThemeData get theme {
    return _theme.copyWith(
      primaryColor: primaryColor,
      accentColor: accentColor,
      buttonColor: buttonColor,

      // text
      textTheme: _textTheme.copyWith(
          title: _textTheme.title.copyWith(
            fontSize: 48.0,
            letterSpacing: 6.0,
            color: Colors.white,
            fontFamily: "Comfortaa",
            fontWeight: FontWeight.w300,
          ),
          subtitle: _textTheme.subtitle.copyWith(
            fontSize: 18.0,
            letterSpacing: 2.0,
            color: Colors.white,
            fontFamily: "Comfortaa",
            fontWeight: FontWeight.w300,
          ),
          button: _textTheme.button.copyWith(
            color: primaryColor,
            fontSize: 16.0,
          ),

          // drawer username
          display1: _textTheme.display1.copyWith(
            fontSize: 14.0,
          ),

          // drawer name
          display2: _textTheme.display2.copyWith(
            fontSize: 24.0,
          ),

          // default text
          body1: _textTheme.body1.copyWith(
            fontSize: 14.0,
          ),

          // username
          caption: _textTheme.caption.copyWith(
            fontSize: 12.0,
          )),
    );
  }
}
