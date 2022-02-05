import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/theme/harpy_theme_data.dart';

/// The minimum recommended contrast ratio for the visual representation of
/// text.
///
/// See https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html.
const kTextContrastRatio = 4.5;

/// The minimum recommended contrast ratio for the visual representation of
/// large text.
///
/// See https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html.
const kLargeTextContrastRatio = 3.0;

/// The default border radius used throughout the app.
const kShapeBorder = RoundedRectangleBorder(
  borderRadius: kBorderRadius,
);
const kBorderRadius = BorderRadius.all(kRadius);
const kRadius = Radius.circular(16);

/// The default animation durations.
const kShortAnimationDuration = Duration(milliseconds: 300);
const kLongAnimationDuration = Duration(milliseconds: 600);

/// The default fonts.
const kBodyFontFamily = 'OpenSans';
const kDisplayFontFamily = 'Comfortaa';

const kAssetFonts = [
  kBodyFontFamily,
  kDisplayFontFamily,
];

const _fontFamilyFallback = ['NotoSans'];

class HarpyTheme {
  HarpyTheme.fromData({
    required HarpyThemeData data,
    required this.config,
  }) {
    name = data.name;
    backgroundColors = data.backgroundColors.map(Color.new).toList();
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

  Color get foregroundColor =>
      brightness == Brightness.light ? Colors.black : Colors.white;

  SystemUiOverlayStyle get systemUiStyle => SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarBrightness: statusBarBrightness,
        statusBarIconBrightness: statusBarIconBrightness,
        systemNavigationBarColor: navBarColor,
        systemNavigationBarDividerColor: navBarColor,
        systemNavigationBarIconBrightness: navBarIconBrightness,
      );

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
        Colors.pinkAccent[200]!,
        Colors.pinkAccent[400]!,
      ],
      baseLuminance: _backgroundLuminance,
    );

    retweetColor = _calculateBestContrastColor(
      colors: [
        Colors.lightGreen[500]!,
        Colors.green[700]!,
      ],
      baseLuminance: _backgroundLuminance,
    );

    translateColor = _calculateBestContrastColor(
      colors: [
        Colors.lightBlueAccent[200]!,
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
    final fontSizeDelta = config.fontSizeDelta;

    final textColor = foregroundColor;

    _textTheme = brightness == Brightness.light
        ? Typography.blackMountainView
        : Typography.whiteMountainView;

    _textTheme = _textTheme
        .copyWith(
          // display
          displayLarge: _applyCustomDisplayFont(
            textStyle: const TextStyle(
              fontSize: 64,
              letterSpacing: 6,
              fontWeight: FontWeight.w300,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),
          displayMedium: _applyCustomDisplayFont(
            textStyle: const TextStyle(
              fontSize: 48,
              letterSpacing: 2,
              fontWeight: FontWeight.w300,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),
          displaySmall: _applyCustomDisplayFont(
            textStyle: const TextStyle(
              fontSize: 48,
              letterSpacing: 0,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),

          // headline
          headlineLarge: _applyCustomDisplayFont(
            textStyle: const TextStyle(
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.w300,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),
          headlineMedium: _applyCustomDisplayFont(
            textStyle: const TextStyle(
              fontSize: 18,
              letterSpacing: 2,
              fontWeight: FontWeight.w300,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),
          headlineSmall: _applyCustomDisplayFont(
            textStyle: const TextStyle(
              fontSize: 20,
              letterSpacing: 2,
              fontWeight: FontWeight.w300,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),

          // title
          titleLarge: _applyCustomDisplayFont(
            textStyle: const TextStyle(
              fontSize: 20,
              letterSpacing: 2,
              fontWeight: FontWeight.w300,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),
          titleMedium: _applyCustomDisplayFont(
            textStyle: const TextStyle(
              fontSize: 16,
              letterSpacing: 1,
              fontWeight: FontWeight.w300,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),
          titleSmall: _applyCustomDisplayFont(
            textStyle: const TextStyle(
              height: 1.1,
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),

          // body
          bodyLarge: _applyCustomBodyFont(
            textStyle: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(.7),
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),
          bodyMedium: _applyCustomBodyFont(
            textStyle: const TextStyle(
              fontSize: 16,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),
          bodySmall: _applyCustomBodyFont(
            textStyle: const TextStyle(
              fontSize: 12,
              letterSpacing: .4,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),

          // label
          labelLarge: _applyCustomDisplayFont(
            textStyle: TextStyle(
              fontSize: 16,
              letterSpacing: 1.2,
              color: buttonTextColor,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),
          labelMedium: _applyCustomDisplayFont(
            textStyle: TextStyle(
              fontSize: 14,
              letterSpacing: 1.2,
              color: buttonTextColor,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),
          labelSmall: _applyCustomBodyFont(
            textStyle: const TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              fontFamilyFallback: _fontFamilyFallback,
            ),
          ),
        )
        .apply(fontSizeDelta: fontSizeDelta);
  }

  TextStyle _applyCustomDisplayFont({
    required TextStyle textStyle,
  }) {
    return applyGoogleFont(
      textStyle: textStyle,
      fontFamily: config.displayFont,
      fallback: kDisplayFontFamily,
    );
  }

  TextStyle _applyCustomBodyFont({
    required TextStyle textStyle,
  }) {
    return applyGoogleFont(
      textStyle: textStyle,
      fontFamily: config.bodyFont,
      fallback: kBodyFontFamily,
    );
  }

  void _setupThemeData() {
    final dividerColor = brightness == Brightness.dark
        ? Colors.white.withOpacity(.2)
        : Colors.black.withOpacity(.2);

    themeData = ThemeData.from(
      colorScheme: ColorScheme(
        primary: primaryColor,
        primaryContainer: primaryColor,
        secondary: secondaryColor,
        secondaryContainer: secondaryColor,
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
      // used by toggleable widgets
      toggleableActiveColor: secondaryColor,

      // used when interacting with material widgets
      splashColor: secondaryColor.withOpacity(.1),
      highlightColor: secondaryColor.withOpacity(.1),

      dividerColor: dividerColor,

      cardTheme: CardTheme(
        color: cardColor,
        shape: kShapeBorder,
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
        shape: kShapeBorder,
        behavior: SnackBarBehavior.floating,
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: averageBackgroundColor,
        shape: kShapeBorder,
      ),

      iconTheme: const IconThemeData.fallback().copyWith(
        color: foregroundColor,
        size: 20 + config.fontSizeDelta,
      ),

      scrollbarTheme: ScrollbarThemeData(
        radius: kRadius,
        thickness: MaterialStateProperty.resolveWith((_) => 3),
        mainAxisMargin: config.paddingValue * 2,
        thumbColor: MaterialStateColor.resolveWith(
          (state) => state.contains(MaterialState.dragged)
              ? secondaryColor.withOpacity(.8)
              : secondaryColor.withOpacity(.4),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(borderRadius: kBorderRadius),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: dividerColor),
          borderRadius: kBorderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: kBorderRadius,
        ),
        contentPadding: config.edgeInsets,
      ),

      appBarTheme: AppBarTheme(systemOverlayStyle: systemUiStyle),
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

TextStyle applyGoogleFont({
  required TextStyle textStyle,
  required String fontFamily,
  String? fallback,
}) {
  if (kAssetFonts.contains(fontFamily)) {
    return textStyle.copyWith(fontFamily: fontFamily);
  }

  try {
    return GoogleFonts.getFont(fontFamily, textStyle: textStyle);
  } catch (e) {
    return fallback != null
        ? textStyle.copyWith(fontFamily: fallback)
        : textStyle;
  }
}
