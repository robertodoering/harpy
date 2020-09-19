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

    _setupAverageBackgroundColor();
    _calculateBrightness();
    _calculateButtonTextColor();
    _calculateErrorColor();
    _setupTweetColors();
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

  /// The accent color of the theme.
  Color accentColor;

  /// The average luminance of the [backgroundColors].
  double backgroundLuminance;

  /// The average color of the [backgroundColors].
  ///
  /// Used as the background color where only a single color is desired (e.g.
  /// the dialog background or a pop up menu).
  Color averageBackgroundColor;

  /// The brightness of the theme.
  ///
  /// The brightness is dependent on the [backgroundLuminance] and determines
  /// whether to use white or black foreground colors.
  Brightness brightness;

  /// The color of the text used by buttons.
  Color buttonTextColor;

  /// The error color of the theme.
  ///
  /// Is [Colors.red] if the contrast ratio on the background exceeds
  /// [kTextContrastRatio].
  /// Otherwise the [accentColor] is used as the error color.
  Color errorColor;

  /// The text theme of the theme.
  TextTheme textTheme;

  /// The [ThemeData] used by the root [MaterialApp].
  ThemeData data;

  /// The color for the like button.
  Color likeColor = Colors.red;

  /// The color for the retweet button.
  Color retweetColor = Colors.green;

  /// The color for the translate button.
  Color translateColor = Colors.blue;

  /// The opposite of [brightness].
  Brightness get complementaryBrightness =>
      brightness == Brightness.light ? Brightness.dark : Brightness.light;

  /// Either [Colors.black] or [Colors.white] depending on the theme brightness.
  ///
  /// This is the color that the text that is written on the background should
  /// have.
  Color get foregroundColor =>
      brightness == Brightness.light ? Colors.black : Colors.white;

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

  /// Reduces the [backgroundColor] to a single color by interpolating the
  /// colors.
  void _setupAverageBackgroundColor() {
    final Color average = backgroundColors
        .reduce((Color value, Color element) => Color.lerp(value, element, .5));

    averageBackgroundColor = average;
  }

  void _setupTweetColors() {
    final List<Color> likeColors = <Color>[
      const Color(0xFFFF4538), // light red
      const Color(0xFF940C01), // dark red
    ];

    final List<Color> retweetColors = <Color>[
      const Color(0xFF94E096), // light green
      const Color(0xFF347736), // dark green
    ];

    final List<Color> translateColors = <Color>[
      const Color(0xFF6EB7EF), // light blue
      const Color(0xFF0F578E), // dark blue
    ];

    final double likeContrast = contrastRatio(
      likeColor.computeLuminance(),
      backgroundLuminance,
    );

    for (Color color in likeColors) {
      if (contrastRatio(color.computeLuminance(), backgroundLuminance) >
          likeContrast) {
        likeColor = color;
      }
    }

    final double retweetContrast = contrastRatio(
      retweetColor.computeLuminance(),
      backgroundLuminance,
    );

    for (Color color in retweetColors) {
      if (contrastRatio(color.computeLuminance(), backgroundLuminance) >
          retweetContrast) {
        retweetColor = color;
      }
    }

    final double translateContrast = contrastRatio(
      translateColor.computeLuminance(),
      backgroundLuminance,
    );

    for (Color color in translateColors) {
      if (contrastRatio(color.computeLuminance(), backgroundLuminance) >
          translateContrast) {
        translateColor = color;
      }
    }
  }

  /// Calculates the button text color, which is the [averageBackgroundColor] if
  /// the contrast ratio is at least [kTextContrastRatio], or white / black
  /// depending on the [brightness].
  void _calculateButtonTextColor() {
    final double ratio = contrastRatio(
      averageBackgroundColor.computeLuminance(),
      foregroundColor.computeLuminance(),
    );

    buttonTextColor = ratio >= kTextContrastRatio
        ? averageBackgroundColor
        : brightness == Brightness.dark ? Colors.black : Colors.white;
  }

  /// Calculates the error color, which is [Colors.red] if the contrast ratio is
  /// at least [kTextContrastRatio], or the [accentColor].
  void _calculateErrorColor() {
    final double ratio = contrastRatio(
      Colors.red.computeLuminance(),
      backgroundLuminance,
    );

    errorColor = ratio >= kTextContrastRatio ? Colors.red : accentColor;
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
      primaryColor: accentColor,
      accentColor: accentColor,
      buttonColor: foregroundColor,
      errorColor: errorColor,

      dividerColor: brightness == Brightness.dark
          ? Colors.white.withOpacity(.2)
          : Colors.black.withOpacity(.2),

      // determines the status bar icon color
      primaryColorBrightness: brightness,

      // used for the background color of material widgets
      cardColor: averageBackgroundColor,
      canvasColor: averageBackgroundColor,
      dialogBackgroundColor: averageBackgroundColor,
      scaffoldBackgroundColor: averageBackgroundColor,

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
