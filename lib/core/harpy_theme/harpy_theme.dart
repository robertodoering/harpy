import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harpy/core/core.dart';

part 'harpy_text_theme.dart';
part 'harpy_theme_colors.dart';

class HarpyTheme {
  HarpyTheme({
    required HarpyThemeData data,
    required double fontSizeDelta,
    required String displayFont,
    required String bodyFont,
  }) {
    name = data.name;
    harpyColors = HarpyThemeColors(data: data);

    harpyTextTheme = HarpyTextTheme(
      brightness: harpyColors.brightness,
      fontSizeDelta: fontSizeDelta,
      displayFont: displayFont,
      bodyFont: bodyFont,
    );

    _setupThemeData();
  }

  late final String name;

  late final HarpyThemeColors harpyColors;
  late final HarpyTextTheme harpyTextTheme;

  late final ThemeData themeData;

  void _setupThemeData() {
    themeData = ThemeData.from(
      colorScheme: ColorScheme(
        brightness: harpyColors.brightness,
        primary: harpyColors.primary,
        onPrimary: harpyColors.onPrimary,
        secondary: harpyColors.secondary,
        onSecondary: harpyColors.onSecondary,
        error: harpyColors.error,
        onError: harpyColors.onError,
        background: harpyColors.averageBackgroundColor,
        onBackground: harpyColors.onBackground,
        surface: harpyColors.cardColor,
        onSurface: harpyColors.onBackground,
      ),
    ).copyWith(
      textTheme: harpyTextTheme.textTheme,
      // TODO: theme overrides
    );
  }

  @override
  String toString() {
    return '$runtimeType: $name';
  }
}
