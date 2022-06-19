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
    required this.data,
    required double fontSizeDelta,
    required String displayFont,
    required String bodyFont,
    required double paddingValue,
  })  : _fontSizeDelta = fontSizeDelta,
        _paddingValue = paddingValue,
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

  final HarpyThemeData data;

  final double _fontSizeDelta;
  final double _paddingValue;

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
        surface: colors.averageBackgroundColor,
        onSurface: colors.onBackground,
      ),
    ).copyWith(
      textTheme: text.textTheme,
      useMaterial3: true,

      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

      // used when interacting with material widgets
      splashColor: colors.secondary.withOpacity(.1),
      highlightColor: colors.secondary.withOpacity(.1),
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
      dialogTheme: DialogTheme(shape: shape),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) =>
              states.contains(MaterialState.selected) ? colors.primary : null,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (state) =>
              state.contains(MaterialState.selected) ? colors.primary : null,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? colors.primary.withAlpha(0x80)
              : null,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: shape,
        enableFeedback: true,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: _paddingValue,
              vertical: _paddingValue * .66,
            ),
          ),
          minimumSize: MaterialStateProperty.all(Size.zero),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: borderRadius),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: _paddingValue,
              vertical: _paddingValue * .66,
            ),
          ),
          minimumSize: MaterialStateProperty.all(Size.zero),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.disabled)
                ? colors.primary.withOpacity(.12)
                : colors.primary,
          ),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.disabled)
                ? colors.onPrimary.withOpacity(.38)
                : colors.onPrimary,
          ),
          overlayColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) {
              return colors.onPrimary.withOpacity(0.08);
            } else if (states.contains(MaterialState.focused) ||
                states.contains(MaterialState.pressed)) {
              return colors.onPrimary.withOpacity(0.24);
            } else {
              return null;
            }
          }),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.all(_paddingValue),
        border: OutlineInputBorder(borderRadius: borderRadius),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colors.primary,
        thumbColor: colors.primary,
        valueIndicatorColor: colors.primary.withOpacity(.8),
        valueIndicatorTextStyle: text.textTheme.subtitle1!.copyWith(
          color: colors.onPrimary,
          fontSize: 13,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        padding: EdgeInsets.all(_paddingValue / 2),
        textStyle: text.textTheme.subtitle2
            ?.copyWith(color: colors.onPrimary)
            .apply(fontSizeDelta: -2),
        preferBelow: false,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: colors.primary,
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(radius: radius),
      // only used in license page
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        color: colors.averageBackgroundColor,
      ),
    );
  }

  @override
  String toString() {
    return '$runtimeType: $name';
  }
}
