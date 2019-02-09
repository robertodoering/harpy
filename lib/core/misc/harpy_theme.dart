import 'package:flutter/material.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';

class HarpyTheme {
  /// The default light theme.
  HarpyTheme.light() {
    name = "Default light";
    defaultTheme = true;
    _initBaseTheme("light");

    primaryColor = Colors.indigo;
    accentColor = Colors.indigoAccent;
  }

  /// The default dark theme.
  HarpyTheme.dark() {
    name = "Default dark";
    defaultTheme = true;
    _initBaseTheme("dark");

    accentColor = Colors.deepPurpleAccent;
  }

  /// Creates a [HarpyTheme] from [HarpyThemeData].
  HarpyTheme.custom(HarpyThemeData harpyThemeData) {
    _initBaseTheme(harpyThemeData.base);

    name = harpyThemeData.name;

    primaryColor =
        Color(harpyThemeData.primaryColor ?? _baseTheme.primaryColor.value);
    accentColor =
        Color(harpyThemeData.accentColor ?? _baseTheme.accentColor.value);
    scaffoldBackgroundColor = Color(harpyThemeData.scaffoldBackgroundColor ??
        _baseTheme.scaffoldBackgroundColor.value);
    secondaryBackgroundColor = Color(harpyThemeData.secondaryBackgroundColor ??
        _baseTheme.scaffoldBackgroundColor.value);
    likeColor = Color(harpyThemeData.likeColor ?? likeColor.value);
    retweetColor = Color(harpyThemeData.retweetColor ?? retweetColor.value);
  }

  /// The color that will be drawn in the splash screen and [LoginScreen].
  static const Color harpyColor = Colors.indigo;

  /// `true` if the theme is the default light or dark theme.
  bool defaultTheme = false;

  String name;
  String base;

  ThemeData _baseTheme;

  Color primaryColor;
  Color accentColor;
  Color scaffoldBackgroundColor;
  Color secondaryBackgroundColor;

  Color likeColor = Colors.red;
  Color retweetColor = Colors.green;

  Brightness get primaryColorBrightness {
    if (_primaryColorBrightness == null) {
      _primaryColorBrightness =
          ThemeData.estimateBrightnessForColor(_baseTheme.primaryColor);
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

  /// Returns [Colors.black] if the [color] is a bright color or [Colors.white]
  /// if it is a dark color.
  static Color complimentaryColor(Color color) {
    switch (ThemeData.estimateBrightnessForColor(color)) {
      case Brightness.dark:
        return Colors.white;
      case Brightness.light:
      default:
        return Colors.black;
    }
  }

  ThemeData get theme {
    final textTheme = ThemeData.light().textTheme.apply(fontFamily: "OpenSans");

    return _baseTheme.copyWith(
      primaryColor: primaryColor,
      accentColor: accentColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,

      backgroundColor: secondaryBackgroundColor,
      dialogBackgroundColor: secondaryBackgroundColor,
      canvasColor: secondaryBackgroundColor, // drawer background

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
      textTheme: textTheme.copyWith(
          title: textTheme.title.copyWith(
            fontSize: 48.0,
            letterSpacing: 6.0,
            color: Colors.white,
            fontFamily: "Comfortaa",
            fontWeight: FontWeight.w300,
          ),
          subtitle: textTheme.subtitle.copyWith(
            fontSize: 18.0,
            letterSpacing: 2.0,
            color: Colors.white,
            fontFamily: "Comfortaa",
            fontWeight: FontWeight.w300,
          ),
          button: textTheme.button.copyWith(
            color: primaryColor,
            fontSize: 16.0,
          ),

          // drawer username
          display1: textTheme.display1.copyWith(
            fontSize: 14.0,
          ),

          // drawer name
          display2: textTheme.display2.copyWith(
            fontSize: 24.0,
          ),

          // settings header
          display3: textTheme.display2.copyWith(
            fontSize: 18.0,
          ),

          // default text
          body1: textTheme.body1.copyWith(
            fontSize: 14.0,
          ),

          // username
          caption: textTheme.caption.copyWith(
            fontSize: 12.0,
          )),
    );
  }

  void _initBaseTheme(String base) {
    this.base = base;
    _baseTheme = base == "light" ? ThemeData.light() : ThemeData.dark();
  }
}
