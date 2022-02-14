import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

part 'theme_preferences.freezed.dart';

final themePreferencesProvider =
    StateNotifierProvider<ThemePreferencesNotifer, ThemePreferences>(
  (ref) {
    final prefix = ref.watch(authPreferencesProvider).userId;

    return ThemePreferencesNotifer(
      preferences: ref.watch(preferencesProvider(prefix)),
    );
  },
  name: 'ThemePreferencesProvider',
);

class ThemePreferencesNotifer extends StateNotifier<ThemePreferences> {
  ThemePreferencesNotifer({
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

  void setCustomThemes(BuiltList<String> customThemes) {
    state = state.copyWith(customThemes: customThemes);
    _preferences.setStringList('customThemes', customThemes.toList());
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
