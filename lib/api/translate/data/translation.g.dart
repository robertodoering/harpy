// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Translation _$TranslationFromJson(Map<String, dynamic> json) {
  return Translation(
    original: json['original'] as String?,
    text: json['text'] as String?,
    languageCode: json['language_code'] as String?,
    language: json['language'] as String?,
  );
}

Map<String, dynamic> _$TranslationToJson(Translation instance) =>
    <String, dynamic>{
      'original': instance.original,
      'text': instance.text,
      'language_code': instance.languageCode,
      'language': instance.language,
    };
