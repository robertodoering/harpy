import 'dart:math';

import 'package:flutter/material.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_bloc.dart';
import 'package:harpy/core/theme/harpy_theme_data.dart';

/// The minimum recommended contrast ratio for the visual representation of
/// text.
///
/// See https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html.
const double kTextContrastRatio = 4.5;

/// The minimum recommended contrast ratio for the visual representation of
/// large text.
///
/// See https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html.
const double kLargeTextContrastRatio = 3;

class HarpyTheme {
  HarpyTheme.fromData(HarpyThemeData data) {
    name = data.name ?? '';

    backgroundColors = data.backgroundColors?.map(_colorFromValue)?.toList() ??
        <Color>[Colors.black, const Color(0xff17233d)];

    accentColor = _colorFromValue(data.accentColor) ?? const Color(0xff6b99ff);

    _calculateBrightness();
    _calculateButtonTextColor();
    _setupTextTheme();
    _setupThemeData();
  }

  /// Returns the currently selected [HarpyTheme].
  static HarpyTheme of(BuildContext context) {
    return ThemeBloc.of(context).harpyTheme;
  }

  /// Calculates the contrast ratio of two colors using the W3C accessibility
  /// guidelines.
  ///
  /// Values range from 1 (no contrast) to 21 (max contrast).
  ///
  /// See https://www.w3.org/TR/WCAG20/#contrast-ratiodef.
  static double contrastRatio(double firstLuminance, double secondLuminance) {
    return (max(firstLuminance, secondLuminance) + 0.05) /
        (min(firstLuminance, secondLuminance) + 0.05);
  }

  /// The name of the theme.
  String name;

  /// A list of colors that define the background gradient.
  List<Color> backgroundColors;

  Color get primaryColor => backgroundColors.last;

  /// The accent color of the theme.
  Color accentColor;

  /// The brightness of the theme.
  Brightness brightness;

  /// The color used by buttons.
  Color buttonTextColor;

  /// The text theme of the theme.
  TextTheme textTheme;

  /// The [ThemeData] used by the root [MaterialApp].
  ThemeData data;

  /// The opposite of [brightness].
  Brightness get complementaryBrightness =>
      brightness == Brightness.light ? Brightness.dark : Brightness.light;

  /// Either [Colors.black] or [Colors.white] depending on the background
  /// brightness.
  ///
  /// This is the color that the text that is written on the background should
  /// have.
  Color get foregroundColor =>
      brightness == Brightness.light ? Colors.black : Colors.white;

  /// The average luminance of the [backgroundColors].
  double backgroundLuminance;

  /// Calculates the background brightness by averaging the relative luminance
  /// of each background color.
  ///
  /// Similar to [ThemeData.estimateBrightnessForColor] for multiple colors.
  void _calculateBrightness() {
    backgroundLuminance = backgroundColors
            .map((Color color) => color.computeLuminance())
            .reduce((double a, double b) => a + b) /
        backgroundColors.length;

    // the Material Design color brightness threshold
    const double kThreshold = 0.15;

    brightness =
        (backgroundLuminance + 0.05) * (backgroundLuminance + 0.05) > kThreshold
            ? Brightness.light
            : Brightness.dark;
  }

  /// Calculates the button text color, which is the [primaryColor] if the
  /// contrast ratio is at least [kTextContrastRatio], or white / black
  /// depending on the button color contrast.
  void _calculateButtonTextColor() {
    final double ratio = contrastRatio(
      foregroundColor.computeLuminance(),
      primaryColor.computeLuminance(),
    );

    if (ratio >= kTextContrastRatio) {
      buttonTextColor = primaryColor;
    } else {
      buttonTextColor =
          brightness == Brightness.dark ? Colors.black : Colors.white;
    }
  }

  void _setupTextTheme() {
    const String displayFont = 'Comfortaa';
    const String bodyFont = 'OpenSans';

    final Color textColor = foregroundColor;

    textTheme = Typography.englishLike2018.apply(fontFamily: bodyFont).copyWith(
          // headline
          headline1: TextStyle(
            fontSize: 64,
            letterSpacing: 6,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: textColor,
          ),
          headline2: TextStyle(
            fontSize: 48,
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: textColor,
          ),
          headline3: TextStyle(
            fontFamily: displayFont,
            color: textColor,
          ),
          headline4: TextStyle(
            fontSize: 18,
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: textColor.withOpacity(0.8),
          ),
          headline6: TextStyle(
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: textColor,
          ),

          // subtitle
          subtitle1: TextStyle(
            letterSpacing: 1,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: textColor.withOpacity(0.9),
          ),
          subtitle2: TextStyle(
            height: 1.1,
            fontSize: 16,
            fontFamily: bodyFont,
            fontWeight: FontWeight.w300,
            color: textColor,
          ),

          // body
          bodyText2: const TextStyle(
            fontSize: 16,
            fontFamily: bodyFont,
          ),
          bodyText1: TextStyle(
            fontSize: 14,
            fontFamily: bodyFont,
            color: textColor.withOpacity(0.7),
          ),

          button: TextStyle(
            fontSize: 16,
            letterSpacing: 1.2,
            fontFamily: bodyFont,
            color: buttonTextColor,
          ),
        );
  }

  void _setupThemeData() {
    data = ThemeData(
      brightness: brightness,
      textTheme: textTheme,
      primaryColor: primaryColor,
      accentColor: accentColor,
      buttonColor: foregroundColor,

      dividerColor: brightness == Brightness.dark
          ? Colors.white.withOpacity(.2)
          : Colors.black.withOpacity(.2),

      // determines the status bar icon color
      primaryColorBrightness: brightness,

      // used for the background color of material widgets
      cardColor: primaryColor,
      canvasColor: primaryColor,

      // used by toggleable widgets
      toggleableActiveColor: accentColor,

      // used by a text field when it has focus
      textSelectionHandleColor: accentColor,

      cardTheme: CardTheme(
        // use the accent color and make it slightly brighter / darker
        color: Color.lerp(
          accentColor.withOpacity(.1),
          brightness == Brightness.dark
              ? Colors.white.withOpacity(.2)
              : Colors.black.withOpacity(.2),
          .1,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  String toString() {
    return 'HarpyTheme: {'
        'name: $name, '
        'accentColor: $accentColor, '
        'backgroundColors: $backgroundColors'
        '}';
  }
}

Color _colorFromValue(int value) => value != null ? Color(value) : null;
