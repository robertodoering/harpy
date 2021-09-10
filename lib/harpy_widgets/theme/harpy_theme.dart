import 'dart:math';

import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
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
  HarpyTheme.fromData({
    required HarpyThemeData data,
    required this.config,
  }) {
    name = data.name;
    backgroundColors =
        data.backgroundColors.map((color) => Color(color)).toList();
    if (backgroundColors.isEmpty) {
      backgroundColors = [Colors.black];
    }
    primaryColor = Color(data.primaryColor);
    secondaryColor = Color(data.secondaryColor);
    statusBarColor = Color(data.statusBarColor);
    navBarColor = Color(data.navBarColor);

    _setupAverageBackgroundColor();
    _setupBrightness();
    _setupCardColor(data.cardColor);
    _setupButtonTextColor();
    _setupErrorColor();
    _setupForegroundColors();
    _setupTweetActionColors();
    _setupSystemUiColors();
    _setupTextTheme();
    _setupThemeData();
  }

  final Config config;

  // custom harpy theme values
  late String name;
  late List<Color> backgroundColors;
  late Color primaryColor;
  late Color secondaryColor;
  late Color cardColor;
  late Color statusBarColor;
  late Color navBarColor;

  // colors chosen based on their background contrast
  late Color buttonTextColor;
  late Color errorColor;
  late Color favoriteColor;
  late Color retweetColor;
  late Color translateColor;

  // calculated values
  late Color averageBackgroundColor;
  late Color alternateCardColor;
  late Color solidCardColor1;
  late Color solidCardColor2;
  late Brightness brightness;
  late Color onPrimary;
  late Color onSecondary;
  late Color onBackground;
  late Color onError;
  late Brightness statusBarBrightness;
  late Brightness statusBarIconBrightness;
  late Brightness navBarIconBrightness;

  late ThemeData themeData;

  late TextTheme _textTheme;
  late double _backgroundLuminance;

  static const List<String> _fontFamilyFallback = ['NotoSans'];

  Color get foregroundColor =>
      brightness == Brightness.light ? Colors.black : Colors.white;

  /// Reduces the [backgroundColors] to a single interpolated color.
  void _setupAverageBackgroundColor() {
    averageBackgroundColor = backgroundColors.reduce(
      (value, element) => Color.lerp(value, element, .5)!,
    );
  }

  /// Calculates the background brightness by averaging the relative luminance
  /// of each background color.
  ///
  /// Similar to [ThemeData.estimateBrightnessForColor] for multiple colors.
  void _setupBrightness() {
    _backgroundLuminance = backgroundColors
            .map((color) => color.computeLuminance())
            .reduce((a, b) => a + b) /
        backgroundColors.length;

    // the Material Design color brightness threshold
    const kThreshold = 0.15;

    brightness = (_backgroundLuminance + 0.05) * (_backgroundLuminance + 0.05) >
            kThreshold
        ? Brightness.light
        : Brightness.dark;
  }

  void _setupCardColor(int? cardColorData) {
    cardColor = cardColorData != null
        ? Color(cardColorData)
        : Color.lerp(
            secondaryColor.withOpacity(.1),
            brightness == Brightness.dark
                ? Colors.white.withOpacity(.2)
                : Colors.black.withOpacity(.2),
            .1,
          )!;

    alternateCardColor =
        Color.lerp(cardColor, averageBackgroundColor, .9)!.withOpacity(.9);

    solidCardColor1 =
        Color.lerp(cardColor, averageBackgroundColor, .85)!.withOpacity(1);

    solidCardColor2 =
        Color.lerp(cardColor, averageBackgroundColor, .775)!.withOpacity(1);
  }

  void _setupButtonTextColor() {
    final ratio = _contrastRatio(
      _backgroundLuminance,
      foregroundColor.computeLuminance(),
    );
    buttonTextColor = ratio >= kTextContrastRatio
        ? averageBackgroundColor
        : brightness == Brightness.dark
            ? Colors.black
            : Colors.white;
  }

  void _setupErrorColor() {
    errorColor = _calculateBestContrastColor(
      colors: [
        const Color(0xFFD21404),
        Colors.red,
        Colors.redAccent,
        Colors.deepOrange,
      ],
      baseLuminance: _backgroundLuminance,
    );
  }

  void _setupForegroundColors() {
    onPrimary = _calculateBestContrastColor(
      colors: [Colors.white, Colors.black],
      baseLuminance: primaryColor.computeLuminance(),
    );

    onSecondary = _calculateBestContrastColor(
      colors: [Colors.white, Colors.black],
      baseLuminance: secondaryColor.computeLuminance(),
    );

    onBackground = _calculateBestContrastColor(
      colors: [Colors.white, Colors.black],
      baseLuminance: _backgroundLuminance,
    );

    onError = _calculateBestContrastColor(
      colors: [Colors.white, Colors.black],
      baseLuminance: errorColor.computeLuminance(),
    );
  }

  /// Contains lighter and darker color variants for the tweet actions and
  /// changes the corresponding color depending on the background contrast.
  void _setupTweetActionColors() {
    favoriteColor = _calculateBestContrastColor(
      colors: [
        Colors.pink[300]!,
        Colors.redAccent[700]!,
      ],
      baseLuminance: _backgroundLuminance,
    );

    retweetColor = _calculateBestContrastColor(
      colors: [
        Colors.lightGreen[100]!,
        Colors.green[800]!,
      ],
      baseLuminance: _backgroundLuminance,
    );

    translateColor = _calculateBestContrastColor(
      colors: [
        Colors.lightBlueAccent[100]!,
        Colors.indigoAccent[700]!,
      ],
      baseLuminance: _backgroundLuminance,
    );
  }

  /// Sets the system ui colors and brightness values based on their color and
  /// transparency.
  ///
  /// If the status bar color has transparency, the estimated color on the
  /// background will be used to determine the brightness.
  void _setupSystemUiColors() {
    statusBarBrightness = ThemeData.estimateBrightnessForColor(
      Color.lerp(
        statusBarColor,
        backgroundColors.first,
        1 - statusBarColor.opacity,
      )!,
    );

    statusBarIconBrightness = _complementaryBrightness(statusBarBrightness);

    navBarIconBrightness = _complementaryBrightness(
      ThemeData.estimateBrightnessForColor(
        Color.lerp(
          navBarColor,
          backgroundColors.last,
          1 - navBarColor.opacity,
        )!,
      ),
    );
  }

  void _setupTextTheme() {
    const displayFont = 'Comfortaa';
    const bodyFont = 'OpenSans';

    final textColor = foregroundColor;

    final fontSizeDelta = config.fontSizeDelta;

    _textTheme = brightness == Brightness.light
        ? Typography.blackMountainView
        : Typography.whiteMountainView;

    _textTheme = _textTheme
        .apply(fontFamily: bodyFont)
        .copyWith(
          // headline
          headline1: const TextStyle(
            fontSize: 64,
            letterSpacing: 6,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),
          headline2: const TextStyle(
            fontSize: 48,
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),
          headline3: const TextStyle(
            fontSize: 48,
            letterSpacing: 0,
            fontFamily: displayFont,
            fontFamilyFallback: _fontFamilyFallback,
          ),
          headline4: const TextStyle(
            fontSize: 18,
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),
          headline5: const TextStyle(
            fontSize: 20,
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),
          headline6: const TextStyle(
            fontSize: 20,
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),

          // subtitle
          subtitle1: const TextStyle(
            fontSize: 16,
            letterSpacing: 1,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),
          subtitle2: const TextStyle(
            height: 1.1,
            fontSize: 16,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: _fontFamilyFallback,
          ),

          // body
          bodyText2: const TextStyle(
            fontSize: 16,
            fontFamilyFallback: _fontFamilyFallback,
          ),
          bodyText1: TextStyle(
            fontSize: 14,
            color: textColor.withOpacity(.7),
            fontFamilyFallback: _fontFamilyFallback,
          ),
          button: TextStyle(
            fontSize: 16,
            letterSpacing: 1.2,
            fontFamily: displayFont,
            color: buttonTextColor,
            fontFamilyFallback: _fontFamilyFallback,
          ),
          caption: const TextStyle(
            fontSize: 12,
            letterSpacing: .4,
            fontFamilyFallback: _fontFamilyFallback,
          ),
          overline: const TextStyle(
            fontSize: 10,
            letterSpacing: 1.5,
            fontFamilyFallback: _fontFamilyFallback,
          ),
        )
        .apply(fontSizeDelta: fontSizeDelta);
  }

  void _setupThemeData() {
    final dividerColor = brightness == Brightness.dark
        ? Colors.white.withOpacity(.2)
        : Colors.black.withOpacity(.2);

    themeData = ThemeData.from(
      colorScheme: ColorScheme(
        primary: primaryColor,
        primaryVariant: primaryColor,
        secondary: secondaryColor,
        secondaryVariant: secondaryColor,
        surface: primaryColor,
        background: averageBackgroundColor,
        error: errorColor,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        onSurface: onPrimary,
        onBackground: onBackground,
        onError: onError,
        brightness: brightness,
      ),
      textTheme: _textTheme,
    ).copyWith(
      // determines the status bar icon color
      primaryColorBrightness: brightness,

      // used by toggleable widgets
      toggleableActiveColor: secondaryColor,

      // used when interacting with material widgets
      splashColor: secondaryColor.withOpacity(.1),
      highlightColor: secondaryColor.withOpacity(.1),

      dividerColor: dividerColor,

      cardTheme: CardTheme(
        color: cardColor,
        shape: kDefaultShapeBorder,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),

      textSelectionTheme: TextSelectionThemeData(
        // cursor color used by text fields
        cursorColor: secondaryColor,
        // used by a text field when it has focus
        selectionHandleColor: secondaryColor,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: foregroundColor,
        backgroundColor: alternateCardColor,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: averageBackgroundColor,
        contentTextStyle: _textTheme.subtitle2,
        actionTextColor: primaryColor,
        disabledActionTextColor: primaryColor.withOpacity(.5),
        shape: kDefaultShapeBorder,
        behavior: SnackBarBehavior.floating,
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: averageBackgroundColor,
        shape: kDefaultShapeBorder,
      ),

      iconTheme: const IconThemeData.fallback().copyWith(
        color: foregroundColor,
        size: 20 + config.fontSizeDelta,
      ),

      scrollbarTheme: ScrollbarThemeData(
        radius: kDefaultRadius,
        thickness: MaterialStateProperty.resolveWith((_) => 3),
        mainAxisMargin: config.paddingValue * 2,
        thumbColor: MaterialStateColor.resolveWith(
          (state) => state.contains(MaterialState.dragged)
              ? secondaryColor.withOpacity(.8)
              : secondaryColor.withOpacity(.4),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(borderRadius: kDefaultBorderRadius),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: dividerColor),
          borderRadius: kDefaultBorderRadius,
        ),
        contentPadding: config.edgeInsets,
      ),
    );
  }
}

/// Returns the color in [colors] that has the best contrast on the
/// [baseLuminance].
Color _calculateBestContrastColor({
  required List<Color> colors,
  required double baseLuminance,
}) {
  assert(colors.isNotEmpty);

  Color? bestColor;
  double? bestLuminance;

  for (final color in colors) {
    final luminance = _contrastRatio(
      color.computeLuminance(),
      baseLuminance,
    );

    if (bestLuminance == null || luminance > bestLuminance) {
      bestLuminance = luminance;
      bestColor = color;
    }
  }

  return bestColor!;
}

Brightness _complementaryBrightness(Brightness brightness) {
  return brightness == Brightness.dark ? Brightness.light : Brightness.dark;
}

/// Calculates the contrast ratio of two colors using the W3C accessibility
/// guidelines.
///
/// Values range from 1 (no contrast) to 21 (max contrast).
///
/// See https://www.w3.org/TR/WCAG20/#contrast-ratiodef.
double _contrastRatio(double firstLuminance, double secondLuminance) {
  return (max(firstLuminance, secondLuminance) + 0.05) /
      (min(firstLuminance, secondLuminance) + 0.05);
}
