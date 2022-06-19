import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation.freezed.dart';

@freezed
class Translation with _$Translation {
  factory Translation({
    required String original,
    required String text,
    required String? languageCode,
    required String? language,
  }) = _Translation;

  Translation._();

  /// Whether the translated text differs from the original.
  ///
  /// This is not the case when the translation service is unable to translate
  /// the text.
  late final isTranslated = original != text;
}
