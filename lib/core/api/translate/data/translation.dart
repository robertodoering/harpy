import 'package:json_annotation/json_annotation.dart';

part 'translation.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class Translation {
  Translation();

  factory Translation.fromJson(Map<String, dynamic> json) =>
      _$TranslationFromJson(json);

  String original;
  String text;
  String languageCode;
  String language;

  bool get unchanged => original == text;

  Map<String, dynamic> toJson() => _$TranslationToJson(this);
}
