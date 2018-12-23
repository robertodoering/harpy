import 'package:json_annotation/json_annotation.dart';

part 'translation.g.dart';

@JsonSerializable()
class Translation {
  String original;
  String text;
  @JsonKey(name: "language_code")
  String languageCode;
  String language;

  bool get unchanged => original == text;

  Translation(
    this.original,
    this.text,
    this.languageCode,
    this.language,
  );

  factory Translation.fromJson(Map<String, dynamic> json) =>
      _$TranslationFromJson(json);

  Map<String, dynamic> toJson() => _$TranslationToJson(this);
}
