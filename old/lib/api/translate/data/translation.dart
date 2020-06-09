import 'package:json_annotation/json_annotation.dart';

part 'translation.g.dart';

@JsonSerializable()
class Translation {
  Translation(
    this.original,
    this.text,
    this.languageCode,
    this.language,
  );

  factory Translation.fromJson(Map<String, dynamic> json) =>
      _$TranslationFromJson(json);

  String original;
  String text;
  @JsonKey(name: "language_code")
  String languageCode;
  String language;

  bool get unchanged => original == text;

  Map<String, dynamic> toJson() => _$TranslationToJson(this);
}
