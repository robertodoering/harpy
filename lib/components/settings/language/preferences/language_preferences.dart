import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/translate/data/languages.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

part 'language_preferences.freezed.dart';

final languagePreferencesProvider =
    StateNotifierProvider<LanguagePreferencesNotifier, LanguagePreferences>(
  (ref) => LanguagePreferencesNotifier(
    preferences: ref.watch(preferencesProvider(null)),
  ),
  name: 'LanguagePreferencesProvider',
);

class LanguagePreferencesNotifier extends StateNotifier<LanguagePreferences> {
  LanguagePreferencesNotifier({
    required Preferences preferences,
  })  : _preferences = preferences,
        super(
          LanguagePreferences(
            translateLanguage: preferences.getString('translateLanguage', ''),
          ),
        );

  final Preferences _preferences;

  void setTranslateLanguage(String value) {
    state = state.copyWith(translateLanguage: value);
    _preferences.setString('translateLanguage', value);
  }
}

@freezed
class LanguagePreferences with _$LanguagePreferences {
  factory LanguagePreferences({
    /// The language code used by the translate service to translate a tweet or
    /// a user description.
    ///
    /// By default the translate language code will derive from the locale of
    /// the app.
    required String translateLanguage,
  }) = _LanguagePreferences;

  LanguagePreferences._();

  String activeTranslateLanguage(Locale locale) => translateLanguage.isNotEmpty
      ? translateLanguage
      : translateLanguageFromLocale(locale) ?? 'en';
}
