import 'package:flutter/material.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';

class HarpyTheme {
  HarpyTheme.light() {
    name = "Default light";
    _initBaseTheme("light");

    primaryColor = Colors.indigo;
    accentColor = Colors.indigoAccent;
    scaffoldBackgroundColor = _baseTheme.scaffoldBackgroundColor;
  }

  HarpyTheme.dark() {
    name = "Default dark";
    _initBaseTheme("dark");

    primaryColor = _baseTheme.primaryColor;
    accentColor = Colors.deepPurpleAccent;
    scaffoldBackgroundColor = _baseTheme.scaffoldBackgroundColor;
  }

  HarpyTheme.custom(HarpyThemeData harpyThemeData) {
    _initBaseTheme(harpyThemeData.base);

    primaryColor = Color(harpyThemeData.primaryColor);
    accentColor = Color(harpyThemeData.accentColor);
    scaffoldBackgroundColor = Color(harpyThemeData.scaffoldBackgroundValue);
  }

  /// The color that will be drawn in the splash screen and [LoginScreen].
  static const Color harpyColor = Colors.indigo;

  String name;
  String base;

  ThemeData _baseTheme;
  TextTheme _textTheme;

  Color primaryColor;
  Color accentColor;
  Color scaffoldBackgroundColor;

  Brightness get primaryColorBrightness {
    if (_primaryColorBrightness == null) {
      _primaryColorBrightness = primaryColor.computeLuminance() > 0.5
          ? Brightness.light
          : Brightness.dark;
    }

    return _primaryColorBrightness;
  }

  Brightness _primaryColorBrightness;

  Color get _primaryComplimentaryColor {
    return primaryColorBrightness != null
        ? primaryColorBrightness == Brightness.light
            ? Colors.black
            : Colors.white
        : null;
  }

  ThemeData get theme {
    return _baseTheme.copyWith(
      primaryColor: primaryColor,
      accentColor: accentColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      backgroundColor: scaffoldBackgroundColor,
      dialogBackgroundColor: scaffoldBackgroundColor,

      buttonColor: Colors.white,

      indicatorColor: accentColor,
      toggleableActiveColor: accentColor,
      textSelectionHandleColor: accentColor,
      textSelectionColor: accentColor,

      // determines the status bar icon color
      primaryColorBrightness: primaryColorBrightness,

      // used for the icon and text color in the appbar
      primaryIconTheme: _baseTheme.primaryIconTheme.copyWith(
        color: _primaryComplimentaryColor,
      ),

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

  void _initBaseTheme(String base) {
    this.base = base;

    if (base == "light") {
      _baseTheme = ThemeData.light();
      _textTheme = ThemeData.light().textTheme.apply(fontFamily: "OpenSans");
    } else {
      _baseTheme = ThemeData.dark();
      _textTheme = ThemeData.dark().textTheme.apply(fontFamily: "OpenSans");
    }
  }
}
