import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:logging/logging.dart';

final harpyThemeProvider = StateProvider(
  (ref) {
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);

    return ref.watch(platformBrightnessProvider) == Brightness.light
        ? lightTheme
        : darkTheme;
  },
  name: 'HarpyThemeProvider',
);

final lightThemeProvider = StateProvider(
  (ref) {
    final lightThemeId = ref.watch(
      themePreferencesProvider.select((value) => value.lightThemeId),
    );
    final customThemes = ref.watch(customThemesProvider);
    final displayPreferences = ref.watch(displayPreferencesProvider);

    return HarpyTheme(
      data: _themeDataFromId(lightThemeId, customThemes) ?? predefinedThemes[1],
      fontSizeDelta: displayPreferences.fontSizeDelta,
      displayFont: displayPreferences.displayFont,
      bodyFont: displayPreferences.bodyFont,
      paddingValue: displayPreferences.paddingValue,
    );
  },
  name: 'LightThemeProvider',
);

final darkThemeProvider = StateProvider(
  (ref) {
    final darkThemeId = ref.watch(
      themePreferencesProvider.select((value) => value.darkThemeId),
    );
    final customThemes = ref.watch(customThemesProvider);
    final displayPreferences = ref.watch(displayPreferencesProvider);

    return HarpyTheme(
      data: _themeDataFromId(darkThemeId, customThemes) ?? predefinedThemes[0],
      fontSizeDelta: displayPreferences.fontSizeDelta,
      displayFont: displayPreferences.displayFont,
      bodyFont: displayPreferences.bodyFont,
      paddingValue: displayPreferences.paddingValue,
    );
  },
  name: 'DarkThemeProvider',
);

final customThemesProvider = StateProvider(
  (ref) => ref
      .watch(themePreferencesProvider.select((value) => value.customThemes))
      .map(_decodeThemeData)
      .whereType<HarpyThemeData>()
      .toBuiltList(),
  name: 'CustomThemesProvider',
);

HarpyThemeData? _themeDataFromId(
  int id,
  BuiltList<HarpyThemeData> customThemes,
) {
  if (id >= 0 && id < predefinedThemes.length) {
    return predefinedThemes[id];
  } else if (id >= 10) {
    if (id - 10 < customThemes.length) {
      return customThemes[id - 10];
    }
  }

  return null;
}

HarpyThemeData? _decodeThemeData(String themeDataJson) {
  try {
    return HarpyThemeData.fromJson(jsonDecode(themeDataJson));
  } catch (e, st) {
    Logger.detached('_decodeThemeData')
        .warning('unable to decode custom theme data', e, st);
    return null;
  }
}
