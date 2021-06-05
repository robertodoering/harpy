import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'translation.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
@immutable
class Translation {
  const Translation({
    this.original,
    this.text,
    this.languageCode,
    this.language,
  });

  factory Translation.fromJson(Map<String, dynamic> json) =>
      _$TranslationFromJson(json);

  final String? original;
  final String? text;
  final String? languageCode;
  final String? language;

  bool get unchanged => original == text;

  Map<String, dynamic> toJson() => _$TranslationToJson(this);
}
