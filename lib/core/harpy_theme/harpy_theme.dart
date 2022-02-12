import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harpy/core/core.dart';

part 'harpy_text_theme.dart';
part 'harpy_theme_colors.dart';

const kShortAnimationDuration = Duration(milliseconds: 300);
const kLongAnimationDuration = Duration(milliseconds: 600);

class HarpyTheme {
  HarpyTheme({
    required HarpyThemeData data,
    required double fontSizeDelta,
    required String displayFont,
    required String bodyFont,
  })  : _fontSizeDelta = fontSizeDelta,
        radius = const Radius.circular(16) {
    borderRadius = BorderRadius.all(radius);
    shape = RoundedRectangleBorder(borderRadius: borderRadius);

    name = data.name;
    colors = HarpyThemeColors(data: data);

    text = HarpyTextTheme(
      brightness: colors.brightness,
      fontSizeDelta: fontSizeDelta,
      displayFont: displayFont,
      bodyFont: bodyFont,
    );

    _setupThemeData();
  }

  final double _fontSizeDelta;

  final Radius radius;
  late final BorderRadius borderRadius;
  late final ShapeBorder shape;

  late final String name;

  late final HarpyThemeColors colors;
  late final HarpyTextTheme text;

  late final ThemeData themeData;

  void _setupThemeData() {
    themeData = ThemeData.from(
      colorScheme: ColorScheme(
        brightness: colors.brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        error: colors.error,
        onError: colors.onError,
        background: colors.averageBackgroundColor,
        onBackground: colors.onBackground,
        surface: colors.cardColor,
        onSurface: colors.onBackground,
      ),
    ).copyWith(
      textTheme: text.textTheme,
      iconTheme: IconThemeData(
        color: colors.onBackground,
        opacity: 1,
        size: 20 + _fontSizeDelta,
      ),
      cardTheme: CardTheme(
        color: colors.cardColor,
        shape: shape,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.alternateCardColor,
        actionTextColor: colors.primary,
        disabledActionTextColor: colors.primary.withOpacity(.5),
        contentTextStyle: text.textTheme.subtitle2,
        elevation: 0,
        shape: shape,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  String toString() {
    return '$runtimeType: $name';
  }
}