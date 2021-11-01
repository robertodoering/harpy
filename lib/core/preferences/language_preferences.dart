import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

class LanguagePreferences {
  const LanguagePreferences();

  /// The language code used by the translate service to translate a tweet or
  /// a user description.
  ///
  /// Returns an empty string when the default value should be used.
  /// By default the translate language code will derive from the locale of the
  /// app.
  String get translateLanguage =>
      app<HarpyPreferences>().getString('translateLanguage', '');
  set translateLanguage(String value) =>
      app<HarpyPreferences>().setString('translateLanguage', value);

  /// Returns the translation language code that should be used for
  /// translations.
  ///
  /// This is [translateLanguage] when a translation has been set or the
  /// default translation language based on the system [languageCode].
  String activeTranslateLanguage(String languageCode) {
    if (hasSetTranslateLanguage) {
      return translateLanguage;
    } else {
      return mapLanguageCodeToTranslateLanguage(
        languageCode,
      );
    }
  }

  /// Whether the user has set their translate language.
  ///
  /// When `true` the [translateLanguage] should be used the translate.
  /// Otherwise the system language should be used to translate.
  bool get hasSetTranslateLanguage => translateLanguage.isNotEmpty;
}
