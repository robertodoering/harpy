import 'package:flutter/material.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';

class HarpyTheme {
  HarpyTheme.light() {
    name = "Default light";
    _baseTheme = ThemeData.light();
    _textTheme = ThemeData.light().textTheme.apply(fontFamily: "OpenSans");
    _primaryColor = Colors.indigo;
    _accentColor = Colors.indigoAccent;
  }

  HarpyTheme.dark() {
    name = "Default dark";
    _baseTheme = ThemeData.dark();
    _textTheme = ThemeData.dark().textTheme.apply(fontFamily: "OpenSans");
    _accentColor = Colors.deepPurpleAccent;
  }

  HarpyTheme.custom(HarpyThemeData harpyThemeData) {
    // todo
    _primaryColor = Color(harpyThemeData.primaryColor);
    _accentColor = Color(harpyThemeData.accentColor);
  }

  /// The color that will be drawn in the splash screen and [LoginScreen].
  static const Color harpyColor = Colors.indigo;

  String name;

  ThemeData _baseTheme;
  TextTheme _textTheme;

  Color _primaryColor;
  Color _primaryColorLight;
  Color _accentColor;

  ThemeData get theme {
    return _baseTheme.copyWith(
      primaryColor: _primaryColor,
      accentColor: _accentColor,
      buttonColor: Colors.white,

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
            color: _primaryColor,
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

          // settings header
          display3: _textTheme.display2.copyWith(
            fontSize: 18.0,
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
