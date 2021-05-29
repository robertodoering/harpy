import 'dart:math';

import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/theme/harpy_theme_data.dart';

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

/// The default border radius used throughout the app.
const ShapeBorder kDefaultShapeBorder = RoundedRectangleBorder(
  borderRadius: kDefaultBorderRadius,
);
const BorderRadius kDefaultBorderRadius = BorderRadius.all(kDefaultRadius);
const Radius kDefaultRadius = Radius.circular(16);

class HarpyTheme {
  HarpyTheme.fromData(HarpyThemeData data) {
    name = data.name;

    backgroundColors =
        data.backgroundColors.map(_colorFromValue).whereType<Color>().toList();

    accentColor = _colorFromValue(data.accentColor) ?? const Color(0xff6b99ff);

    _setupAverageBackgroundColor();
    _calculateBrightness();
    _calculateButtonTextColor();
    _calculateErrorColor();
    _setupTweetActionColors();
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

  late String name;
  late List<Color> backgroundColors;
  late Color accentColor;

  /// The average luminance of the [backgroundColors].
  late double backgroundLuminance;

  /// The average color of the [backgroundColors].
  ///
  /// Used as the background color where only a single color is desired (e.g.
  /// the dialog background or a pop up menu).
  late Color averageBackgroundColor;

  /// The brightness of the theme.
  ///
  /// The brightness is dependent on the [backgroundLuminance] and determines
  /// whether to use white or black foreground colors.
  late Brightness brightness;

  /// The error color of the theme.
  ///
  /// Is [Colors.red] if the contrast ratio on the background exceeds
  /// [kTextContrastRatio].
  /// Otherwise the [accentColor] is used as the error color.
  late Color errorColor;

  late TextTheme textTheme;
  late Color buttonTextColor;
  late Color favoriteColor = Colors.pinkAccent;
  late Color retweetColor = Colors.lightGreenAccent;
  late Color translateColor = Colors.lightBlueAccent;

  /// The [ThemeData] used by the root [MaterialApp].
  late ThemeData data;

  CardTheme get _cardTheme {
    final performanceMode = app<GeneralPreferences>().performanceMode;

    final color = performanceMode
        ? Color.lerp(
            averageBackgroundColor,
            accentColor,
            .1,
          )
        : Color.lerp(
            accentColor.withOpacity(.1),
            brightness == Brightness.dark
                ? Colors.white.withOpacity(.2)
                : Colors.black.withOpacity(.2),
            .1,
          );

    return CardTheme(
      color: color,
      shape: kDefaultShapeBorder,
      elevation: 0,
      margin: EdgeInsets.zero,
    );
  }

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
            .map((color) => color.computeLuminance())
            .reduce((a, b) => a + b) /
        backgroundColors.length;

    // the Material Design color brightness threshold
    const kThreshold = 0.15;

    brightness =
        (backgroundLuminance + 0.05) * (backgroundLuminance + 0.05) > kThreshold
            ? Brightness.light
            : Brightness.dark;
  }

  /// Reduces the [backgroundColors] to a single color by interpolating the
  /// colors.
  void _setupAverageBackgroundColor() {
    final average = backgroundColors.reduce(
      (value, element) => Color.lerp(value, element, .5)!,
    );

    averageBackgroundColor = average;
  }

  /// Contains lighter and darker color variants for the tweet actions and
  /// changes the corresponding color depending on the background contrast.
  ///
  /// This is used to make sure the color looks good on any colored background.
  void _setupTweetActionColors() {
    final favoriteColors = <Color?>[
      Colors.pink[300],
      Colors.redAccent[700],
    ];

    final retweetColors = <Color?>[
      Colors.lightGreen[100],
      Colors.green[800],
    ];

    final translateColors = <Color?>[
      Colors.lightBlueAccent[100],
      Colors.indigoAccent[700],
    ];

    var favoriteContrast = contrastRatio(
      favoriteColor.computeLuminance(),
      backgroundLuminance,
    );

    for (final color in favoriteColors) {
      final contrast = contrastRatio(
        color!.computeLuminance(),
        backgroundLuminance,
      );

      if (contrast > favoriteContrast) {
        favoriteColor = color;
        favoriteContrast = contrast;
      }
    }

    var retweetContrast = contrastRatio(
      retweetColor.computeLuminance(),
      backgroundLuminance,
    );

    for (final color in retweetColors) {
      final contrast = contrastRatio(
        color!.computeLuminance(),
        backgroundLuminance,
      );

      if (contrast > retweetContrast) {
        retweetColor = color;
        retweetContrast = contrast;
      }
    }

    var translateContrast = contrastRatio(
      translateColor.computeLuminance(),
      backgroundLuminance,
    );

    for (final color in translateColors) {
      final contrast = contrastRatio(
        color!.computeLuminance(),
        backgroundLuminance,
      );

      if (contrast > translateContrast) {
        translateColor = color;
        translateContrast = contrast;
      }
    }
  }

  /// Calculates the button text color, which is the [averageBackgroundColor] if
  /// the contrast ratio is at least [kTextContrastRatio], or white / black
  /// depending on the [brightness].
  void _calculateButtonTextColor() {
    final ratio = contrastRatio(
      averageBackgroundColor.computeLuminance(),
      foregroundColor.computeLuminance(),
    );

    buttonTextColor = ratio >= kTextContrastRatio
        ? averageBackgroundColor
        : brightness == Brightness.dark
            ? Colors.black
            : Colors.white;
  }

  /// Calculates the error color, which is [Colors.red] if the contrast ratio is
  /// at least [kTextContrastRatio], or the [accentColor].
  void _calculateErrorColor() {
    final ratio = contrastRatio(
      Colors.red.computeLuminance(),
      backgroundLuminance,
    );

    errorColor = ratio >= kTextContrastRatio ? Colors.red : accentColor;
  }

  void _setupTextTheme() {
    const displayFont = 'Comfortaa';
    const bodyFont = 'OpenSans';

    final textColor = foregroundColor;

    final fontSizeDelta = app<LayoutPreferences>().fontSizeDelta;

    textTheme = Typography.englishLike2018
        .apply(
          fontFamily: bodyFont,
        )
        .copyWith(
          // headline
          headline1: TextStyle(
            fontSize: 64,
            letterSpacing: 6,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: textColor,
            fontFamilyFallback: const <String>['NotoSans'],
          ),
          headline2: TextStyle(
            fontSize: 48,
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: textColor,
            fontFamilyFallback: const <String>['NotoSans'],
          ),
          headline3: TextStyle(
            fontSize: 48,
            fontFamily: displayFont,
            color: textColor,
            fontFamilyFallback: const <String>['NotoSans'],
          ),
          headline4: TextStyle(
            fontSize: 18,
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: textColor.withOpacity(0.8),
            fontFamilyFallback: const <String>['NotoSans'],
          ),
          headline6: TextStyle(
            fontSize: 20,
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: textColor,
            fontFamilyFallback: const <String>['NotoSans'],
          ),

          // subtitle
          subtitle1: TextStyle(
            fontSize: 16,
            letterSpacing: 1,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: textColor.withOpacity(0.9),
            fontFamilyFallback: const <String>['NotoSans'],
          ),
          subtitle2: TextStyle(
            height: 1.1,
            fontSize: 16,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: textColor,
            fontFamilyFallback: const <String>['NotoSans'],
          ),

          // body
          bodyText2: const TextStyle(
            fontSize: 16,
            fontFamily: bodyFont,
            fontFamilyFallback: <String>['NotoSans'],
          ),
          bodyText1: TextStyle(
            fontSize: 14,
            fontFamily: bodyFont,
            color: textColor.withOpacity(0.7),
            fontFamilyFallback: const <String>['NotoSans'],
          ),

          button: TextStyle(
            fontSize: 16,
            letterSpacing: 1.2,
            fontFamily: bodyFont,
            color: buttonTextColor,
            fontFamilyFallback: const <String>['NotoSans'],
          ),
        )
        .apply(fontSizeDelta: fontSizeDelta);
  }

  ColorScheme get _colorScheme => ColorScheme(
        background: averageBackgroundColor,
        brightness: brightness,
        error: errorColor,
        onBackground: foregroundColor,
        onError: foregroundColor,
        onPrimary: foregroundColor,
        onSecondary: foregroundColor,
        onSurface: foregroundColor,
        primary: accentColor,
        primaryVariant: accentColor,
        secondary: accentColor,
        secondaryVariant: accentColor,
        surface: averageBackgroundColor,
      );

  void _setupThemeData() {
    data = ThemeData(
      brightness: brightness,
      textTheme: textTheme,
      primaryColor: accentColor,
      accentColor: accentColor,
      buttonColor: foregroundColor,
      errorColor: errorColor,

      colorScheme: _colorScheme,

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

      // used when interacting with material widgets
      splashColor: accentColor.withOpacity(.1),
      highlightColor: accentColor.withOpacity(.1),

      cardTheme: _cardTheme,

      textSelectionTheme: TextSelectionThemeData(
        // cursor color used by text fields
        cursorColor: accentColor,
        // used by a text field when it has focus
        selectionHandleColor: accentColor,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: foregroundColor,
        backgroundColor: averageBackgroundColor,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: averageBackgroundColor,
        contentTextStyle: textTheme.subtitle2,
        actionTextColor: accentColor,
        disabledActionTextColor: accentColor.withOpacity(.5),
        shape: kDefaultShapeBorder,
        behavior: SnackBarBehavior.floating,
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: averageBackgroundColor,
        shape: kDefaultShapeBorder,
      ),

      iconTheme: const IconThemeData.fallback().copyWith(
        color: foregroundColor,
        size: 20,
      ),

      scrollbarTheme: ScrollbarThemeData(
        radius: kDefaultRadius,
        thickness: MaterialStateProperty.resolveWith((_) => 3),
        mainAxisMargin: 16,
        thumbColor: MaterialStateColor.resolveWith(
          (state) => state.contains(MaterialState.dragged)
              ? accentColor.withOpacity(.8)
              : accentColor.withOpacity(.4),
        ),
      ),
    );
  }
}

Color? _colorFromValue(int? value) => value != null ? Color(value) : null;
