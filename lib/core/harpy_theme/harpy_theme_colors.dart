part of 'harpy_theme.dart';

class HarpyThemeColors {
  HarpyThemeColors({
    required HarpyThemeData data,
  }) {
    backgroundColors = data.backgroundColors.map(Color.new).toBuiltList();
    primary = Color(data.primaryColor);
    secondary = Color(data.secondaryColor);
    cardColor = Color(data.cardColor);
    statusBarColor = Color(data.statusBarColor);
    navBarColor = Color(data.navBarColor);

    _setupAverageBackgroundColor();
    _setupBrightness();
    _setupCardColors();
    _setupErrorColor();
    _setupTweetActionColors();
    _setupForegroundColors();
    _setupSystemUiColors();
  }

  // theme data values
  late final String name;
  late final BuiltList<Color> backgroundColors;
  late final Color primary;
  late final Color secondary;
  late final Color cardColor;
  late final Color statusBarColor;
  late final Color navBarColor;

  // colors chosen based on their background contrast
  late final Color error;
  late final Color favorite;
  late final Color retweet;
  late final Color translate;

  // calculated values
  late final Color averageBackgroundColor;
  late final Brightness brightness;
  late final Color alternateCardColor;
  late final Color solidCardColor1;
  late final Color solidCardColor2;
  late final Color onPrimary;
  late final Color onSecondary;
  late final Color onBackground;
  late final Color onError;

  late final SystemUiOverlayStyle systemUiOverlayStyle;

  late final double _backgroundLuminance;

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

  void _setupCardColors() {
    alternateCardColor =
        Color.lerp(cardColor, averageBackgroundColor, .9)!.withOpacity(.9);

    solidCardColor1 =
        Color.lerp(cardColor, averageBackgroundColor, .85)!.withOpacity(1);

    solidCardColor2 =
        Color.lerp(cardColor, averageBackgroundColor, .775)!.withOpacity(1);
  }

  void _setupErrorColor() {
    error = _calculateBestContrastColor(
      colors: [
        const Color(0xFFD21404),
        Colors.red,
        Colors.redAccent,
        Colors.deepOrange,
      ],
      baseLuminance: _backgroundLuminance,
    );
  }

  /// Contains lighter and darker color variants for the tweet actions and
  /// changes the corresponding color depending on the background contrast.
  void _setupTweetActionColors() {
    favorite = _calculateBestContrastColor(
      colors: [
        Colors.pinkAccent[200]!,
        Colors.pinkAccent[400]!,
      ],
      baseLuminance: _backgroundLuminance,
    );

    retweet = _calculateBestContrastColor(
      colors: [
        Colors.lightGreen[500]!,
        Colors.green[700]!,
      ],
      baseLuminance: _backgroundLuminance,
    );

    translate = _calculateBestContrastColor(
      colors: [
        Colors.lightBlueAccent[200]!,
        Colors.indigoAccent[700]!,
      ],
      baseLuminance: _backgroundLuminance,
    );
  }

  void _setupForegroundColors() {
    onPrimary = _calculateBestContrastColor(
      colors: [Colors.white, Colors.black],
      baseLuminance: primary.computeLuminance(),
    );

    onSecondary = _calculateBestContrastColor(
      colors: [Colors.white, Colors.black],
      baseLuminance: secondary.computeLuminance(),
    );

    onBackground = _calculateBestContrastColor(
      colors: [Colors.white, Colors.black],
      baseLuminance: _backgroundLuminance,
    );

    onError = _calculateBestContrastColor(
      colors: [Colors.white, Colors.black],
      baseLuminance: error.computeLuminance(),
    );
  }

  /// Sets the system ui colors and brightness values based on their color and
  /// transparency.
  ///
  /// If the status bar color has transparency, the estimated color on the
  /// background will be used to determine its brightness.
  void _setupSystemUiColors() {
    final statusBarBrightness = ThemeData.estimateBrightnessForColor(
      Color.lerp(
        statusBarColor,
        backgroundColors.first,
        1 - statusBarColor.opacity,
      )!,
    );

    final statusBarIconBrightness = statusBarBrightness.opposite;

    final navBarIconBrightness = ThemeData.estimateBrightnessForColor(
      Color.lerp(
        navBarColor,
        backgroundColors.last,
        1 - navBarColor.opacity,
      )!,
    ).opposite;

    systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarBrightness: statusBarBrightness,
      statusBarIconBrightness: statusBarIconBrightness,
      systemNavigationBarColor: navBarColor,
      systemNavigationBarDividerColor: navBarColor,
      systemNavigationBarIconBrightness: navBarIconBrightness,
    );
  }
}

/// Returns the color in [colors] that has the best contrast on the
/// [baseLuminance].
Color _calculateBestContrastColor({
  required Iterable<Color> colors,
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

extension on Brightness {
  Brightness get opposite =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;
}
