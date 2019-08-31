// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Translation _$TranslationFromJson(Map<String, dynamic> json) {
  return Translation(
    json['original'] as String,
    json['text'] as String,
    json['language_code'] as String,
    json['language'] as String,
  );
}

Map<String, dynamic> _$TranslationToJson(Translation instance) =>
    <String, dynamic>{
      'original': instance.original,
      'text': instance.text,
      'language_code': instance.languageCode,
      'language': instance.language,
    };
