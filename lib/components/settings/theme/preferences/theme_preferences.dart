import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

part 'theme_preferences.freezed.dart';

final themePreferencesProvider =
    StateNotifierProvider<ThemePreferencesNotifier, ThemePreferences>(
  (ref) {
    final prefix = ref.watch(authPreferencesProvider).userId;

    return ThemePreferencesNotifier(
      preferences: ref.watch(preferencesProvider(prefix)),
    );
  },
  name: 'ThemePreferencesProvider',
);

class ThemePreferencesNotifier extends StateNotifier<ThemePreferences>
    with LoggerMixin {
  ThemePreferencesNotifier({
    required Preferences preferences,
  })  : _preferences = preferences,
        super(
          ThemePreferences(
            lightThemeId: preferences.getInt('lightThemeId', isFree ? 0 : 1),
            darkThemeId: preferences.getInt('darkThemeId', 0),
            customThemes:
                preferences.getStringList('customThemes', []).toBuiltList(),
          ),
        );

  final Preferences _preferences;

  void setThemeId({
    int? lightThemeId,
    int? darkThemeId,
  }) {
    state = state.copyWith(
      lightThemeId: lightThemeId ?? state.lightThemeId,
      darkThemeId: darkThemeId ?? state.darkThemeId,
    );

    if (lightThemeId != null) {
      _preferences.setInt('lightThemeId', lightThemeId);
    }

    if (darkThemeId != null) {
      _preferences.setInt('darkThemeId', darkThemeId);
    }
  }

  void addCustomTheme({
    required HarpyThemeData themeData,
    required int? themeId,
    bool updateLightThemeSelection = false,
    bool updateDarkThemeSelection = false,
  }) {
    try {
      if (themeId != null) {
        // update existing theme
        state = state.copyWith(
          customThemes: state.customThemes.rebuild(
            (builder) => builder[themeId - 10] = jsonEncode(themeData.toJson()),
          ),
        );
      } else {
        // add new theme
        state = state.copyWith(
          customThemes: state.customThemes.rebuild(
            (builder) => builder.add(jsonEncode(themeData.toJson())),
          ),
        );
      }

      _preferences.setStringList('customThemes', state.customThemes.toList());

      if (updateLightThemeSelection || updateDarkThemeSelection) {
        setThemeId(
          lightThemeId: updateLightThemeSelection
              ? themeId ?? state.customThemes.length - 1 + 10
              : null,
          darkThemeId: updateDarkThemeSelection
              ? themeId ?? state.customThemes.length - 1 + 10
              : null,
        );
      }
    } catch (e, st) {
      log.severe('unable to add custom theme', e, st);
    }
  }

  void removeCustomTheme({
    required int themeId,
  }) {
    state = state.copyWith(
      customThemes: state.customThemes.rebuild(
        (builder) => builder.removeAt(themeId - 10),
      ),
    );

    _preferences.setStringList('customThemes', state.customThemes.toList());

    if (themeId <= state.lightThemeId || themeId <= state.darkThemeId) {
      setThemeId(
        lightThemeId: themeId == state.lightThemeId
            ? 0
            : themeId < state.lightThemeId
                ? state.lightThemeId - 1
                : null,
        darkThemeId: themeId == state.darkThemeId
            ? 0
            : themeId < state.darkThemeId
                ? state.darkThemeId - 1
                : null,
      );
    }
  }
}

@freezed
class ThemePreferences with _$ThemePreferences {
  const factory ThemePreferences({
    required int lightThemeId,
    required int darkThemeId,
    required BuiltList<String> customThemes,
  }) = _ThemeSettings;
}
