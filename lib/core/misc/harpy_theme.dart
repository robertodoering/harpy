import 'package:flutter/material.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';

class HarpyTheme {
  /// The default light theme.
  HarpyTheme.light() {
    name = "Default light";
    defaultTheme = true;
    _initBaseTheme("light");

    accentColor = Colors.indigoAccent;

    primaryBackgroundColor = Colors.indigo[50];
    secondaryBackgroundColor = Colors.white;
  }

  /// The default dark theme.
  HarpyTheme.dark() {
    name = "Default dark";
    defaultTheme = true;
    _initBaseTheme("dark");

    accentColor = Colors.deepPurpleAccent;

    primaryBackgroundColor = Colors.grey[850];
    secondaryBackgroundColor = Colors.black;
  }

  /// Creates a [HarpyTheme] from [HarpyThemeData].
  HarpyTheme.custom(HarpyThemeData harpyThemeData) {
    _initBaseTheme(harpyThemeData.base);

    name = harpyThemeData.name;

    // todo: ensure colors are not null
    accentColor = _colorFromValue(harpyThemeData.accentColor);
    primaryBackgroundColor =
        _colorFromValue(harpyThemeData.primaryBackgroundColor);
    secondaryBackgroundColor =
        _colorFromValue(harpyThemeData.secondaryBackgroundColor);
    likeColor = _colorFromValue(harpyThemeData.likeColor);
    retweetColor = _colorFromValue(harpyThemeData.retweetColor);
  }

  /// The color that will be drawn in the splash screen and [LoginScreen].
  static const Color harpyColor = Colors.indigo;

  /// `true` if the theme is the default light or dark theme.
  bool defaultTheme = false;

  String name;
  String base;

  ThemeData _baseTheme;

  // custom colors, must not be null
  Color accentColor;

  Color primaryBackgroundColor;
  Color secondaryBackgroundColor;

  Color likeColor = Colors.red;
  Color retweetColor = Colors.green;

  Brightness get backgroundColor1Brightness => _backgroundColor1Brightness ??=
      ThemeData.estimateBrightnessForColor(primaryBackgroundColor);
  Brightness _backgroundColor1Brightness;

  Color get backgroundComplimentaryColor =>
      backgroundColor1Brightness == Brightness.light
          ? Colors.black
          : Colors.white;

  /// Returns [Colors.black] if the [color] is a bright color or [Colors.white]
  /// if it is a dark color.
  static Color complimentaryColor(Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.light
          ? Colors.black
          : Colors.white;

  ThemeData get theme {
    final textTheme = _baseTheme.textTheme.apply(fontFamily: "OpenSans");

    return _baseTheme.copyWith(
      primaryColor: accentColor,
      accentColor: accentColor,
      scaffoldBackgroundColor: primaryBackgroundColor,
      backgroundColor: primaryBackgroundColor,
      dialogBackgroundColor: primaryBackgroundColor,
      canvasColor: primaryBackgroundColor, // drawer background (base == dark)

      buttonColor: Colors.white,
      indicatorColor: accentColor,
      toggleableActiveColor: accentColor,
      textSelectionHandleColor: accentColor,
      textSelectionColor: accentColor,

      // determines the status bar icon color
      primaryColorBrightness: backgroundColor1Brightness,

      // used for the icon and text color in the appbar
      primaryIconTheme: _baseTheme.primaryIconTheme.copyWith(
        color: backgroundComplimentaryColor,
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
            color: harpyColor,
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

      dialogTheme: _baseTheme.dialogTheme.copyWith(
        titleTextStyle: textTheme.title.copyWith(
          fontSize: 24.0,
          color: Colors.white,
          fontFamily: "Comfortaa",
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Color _colorFromValue(int value) {
    if (value == null) {
      return null;
    }
    return Color(value);
  }

  void _initBaseTheme(String base) {
    this.base = base;
    _baseTheme = base == "light" ? ThemeData.light() : ThemeData.dark();
  }
}
