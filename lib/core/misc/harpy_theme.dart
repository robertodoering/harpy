import 'package:flutter/material.dart';
import 'package:harpy/components/screens/setup_screen.dart';
import 'package:harpy/components/screens/theme_settings_screen.dart';
import 'package:harpy/components/widgets/shared/harpy_background.dart';
import 'package:harpy/components/widgets/theme/theme_card.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';

/// The [HarpyTheme] creates the [ThemeData] from a serializable
/// [HarpyThemeData] that is used by the [MaterialApp].
///
/// The [ThemeSettingsModel] has a reference to the currently selected
/// [HarpyTheme] that can be accessed by calling [HarpyTheme.of].
class HarpyTheme {
  HarpyTheme.fromData(HarpyThemeData data) {
    name = data.name ?? "";

    backgroundColors = data.backgroundColors?.map(_colorFromValue)?.toList();

    if (backgroundColors == null || backgroundColors.length < 2) {
      backgroundColors = [Colors.black, const Color(0xff17233d)];
    }

    accentColor = _colorFromValue(data.accentColor) ?? const Color(0xff6b99ff);
  }

  /// Returns the currently selected [HarpyTheme].
  static HarpyTheme of(BuildContext context) {
    return ThemeSettingsModel.of(context).harpyTheme;
  }

  /// The name of the theme that is used in the [ThemeCard].
  String name;

  /// A list of colors that define the background gradient.
  ///
  /// The [HarpyBackground] uses these colors to build the background gradient.
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

  /// The opposite of [brightness].
  Brightness get complimentaryBrightness =>
      brightness == Brightness.light ? Brightness.dark : Brightness.light;

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

  /// Either [Colors.black] or [Colors.white] depending on the background
  /// brightness.
  ///
  /// This is the color that the text that is written on the background should
  /// have.
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
            height: 1.1,
            fontSize: 16,
            fontFamily: bodyFont,
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

      // used for the background color of material widgets
      cardColor: primaryColor,
      canvasColor: primaryColor,

      // used by toggleable widgets
      toggleableActiveColor: accentColor,

      // used by a textfield when it has focus
      textSelectionHandleColor: accentColor,
    );
  }

  Color _colorFromValue(int value) {
    return value != null ? Color(value) : null;
  }
}

/// The [PredefinedThemes] define [HarpyTheme]s that can be used as the theme
/// for the app.
///
/// These themes are able to be selected in the [SetupScreen] when a user logs
/// in for the first time and in the [ThemeSettingsScreen].
///
/// Unlike custom themes, the [PredefinedThemes] cannot be deleted.
class PredefinedThemes {
  static List<HarpyTheme> get themes {
    if (_themes.isEmpty) {
      _themes.addAll(data.map((themeData) => HarpyTheme.fromData(themeData)));
    }

    return _themes;
  }

  static final List<HarpyTheme> _themes = [];

  static List<HarpyThemeData> get data => [
        crow,
        swan,
        phoenix,
        harpy,
      ];

  static HarpyThemeData get crow {
    return HarpyThemeData()
      ..name = "crow"
      ..backgroundColors = [Colors.black.value, 0xff17233d]
      ..accentColor = 0xff4178f0;
  }

  static HarpyThemeData get phoenix {
    return HarpyThemeData()
      ..name = "phoenix"
      ..backgroundColors = [0xff9e0000, 0xffd1670a]
      ..accentColor = Colors.orangeAccent.value;
  }

  static HarpyThemeData get swan {
    return HarpyThemeData()
      ..name = "swan"
      ..backgroundColors = [Colors.white.value, Colors.white.value]
      ..accentColor = 0xff444444;
  }

  static HarpyThemeData get harpy {
    return HarpyThemeData()
      ..name = "harpy"
      ..backgroundColors = [0xff40148b, 0xff5b1051, 0xff850a2f]
      ..accentColor = 0xffd4d4d4;
  }
}
