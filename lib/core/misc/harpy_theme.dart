import 'package:flutter/material.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';

class HarpyTheme {
  HarpyTheme.fromData(HarpyThemeData data) {
    name = data.name ?? "";

    backgroundColors = data.backgroundColors?.map(_colorFromValue)?.toList();

    if (backgroundColors == null || backgroundColors?.length != 2) {
      backgroundColors = _fallback.backgroundColors;
    }

    accentColor = _colorFromValue(data.accentColor) ?? _fallback.accentColor;
  }

  /// The fallback is used if the [HarpyThemeData] has insufficient data.
  static final HarpyTheme _fallback = PredefinedThemes.themes.first;

  String name;

  /// A list of 2 colors that define the background gradient.
  List<Color> backgroundColors;

  Color get primaryColor => backgroundColors.last;

  /// The accent color should compliment the background color.
  Color accentColor;

  /// Gets the brightness by averaging the relative luminance of each
  /// background color.
  ///
  /// Similar to [ThemeData.estimateBrightnessForColor] for multiple colors.
  Brightness get brightness {
    final double relativeLuminance = backgroundColors
            .map((color) => color.computeLuminance())
            .reduce((a, b) => a + b) /
        backgroundColors.length;

    const double kThreshold = 0.15;

    return ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) >
            kThreshold)
        ? Brightness.light
        : Brightness.dark;
  }

  /// Returns the [primaryColor] if it is not the same brightness as the button
  /// color, otherwise a complimentary color (white / black).
  Color get buttonTextColor {
    final primaryColorBrightness =
        ThemeData.estimateBrightnessForColor(primaryColor);

    if (brightness == Brightness.dark) {
      // button color is light
      return primaryColorBrightness == Brightness.light
          ? Colors.black
          : primaryColor;
    } else {
      // button color is dark
      return primaryColorBrightness == Brightness.dark
          ? Colors.white
          : primaryColor;
    }
  }

  Color get backgroundComplimentaryColor =>
      brightness == Brightness.light ? Colors.black : Colors.white;

  TextTheme get _textTheme {
    const displayFont = "Comfortaa";
    const bodyFont = "OpenSans";

    final complimentaryColor = backgroundComplimentaryColor;

    return Typography.englishLike2018.apply(fontFamily: bodyFont).copyWith(
          // display
          display4: TextStyle(
            fontSize: 64,
            letterSpacing: 6,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: complimentaryColor,
          ),
          display3: TextStyle(
            fontSize: 48,
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: complimentaryColor,
          ),
          display2: TextStyle(
            fontFamily: displayFont,
            color: complimentaryColor,
          ),
          display1: TextStyle(
            fontSize: 18,
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: complimentaryColor.withOpacity(0.8),
          ),

          // title
          title: TextStyle(
            fontFamily: displayFont,
            letterSpacing: 2,
            fontWeight: FontWeight.w300,
            color: complimentaryColor,
          ),

          subhead: TextStyle(
            letterSpacing: 1,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: complimentaryColor.withOpacity(0.9),
          ),

          subtitle: TextStyle(
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: complimentaryColor,
          ),

          // body
          body1: TextStyle(
            fontSize: 16,
            fontFamily: bodyFont,
          ),

          body2: TextStyle(
            fontSize: 14,
            fontFamily: bodyFont,
            color: complimentaryColor.withOpacity(0.7),
          ),

          button: TextStyle(
            fontSize: 16,
            letterSpacing: 1.2,
            fontFamily: bodyFont,
            color: buttonTextColor,
          ),
        );
  }

  ThemeData get theme {
    final complimentaryColor = backgroundComplimentaryColor;

    return ThemeData(
      brightness: brightness,
      textTheme: _textTheme,
      primaryColor: primaryColor,
      accentColor: accentColor,
      buttonColor: complimentaryColor,

      // determines the status bar icon color
      primaryColorBrightness: brightness,

      // used for the background color of Material widgets
      cardColor: primaryColor,
      canvasColor: primaryColor,
    );
  }

  Color _colorFromValue(int value) {
    return value != null ? Color(value) : null;
  }
}

// todo: define theme data for predefined themes ("crow", "phoenix", "swan")
class PredefinedThemes {
  static List<HarpyTheme> get themes {
    return data.map((themeData) => HarpyTheme.fromData(themeData)).toList();
  }

  static List<HarpyThemeData> get data => [
        crow,
        swan,
        phoenix,
      ];

  static HarpyThemeData get crow {
    return HarpyThemeData()
      ..name = "crow"
      ..backgroundColors = [Colors.black.value, 0xff17233d]
      ..accentColor = 0xff6b99ff;
  }

  static HarpyThemeData get phoenix {
    return HarpyThemeData()
      ..name = "phoenix"
      ..backgroundColors = [0xffdd2222, Colors.deepOrange.value]
      ..accentColor = Colors.orangeAccent.value;
  }

  static HarpyThemeData get swan {
    return HarpyThemeData()
      ..name = "swan"
      ..backgroundColors = [Colors.white.value, Colors.white.value]
      ..accentColor = 0xff444444;
  }
}
