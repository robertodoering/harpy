import 'package:json_annotation/json_annotation.dart';

part 'harpy_theme_data.g.dart';

@JsonSerializable()
class HarpyThemeData {
  String name;
  int primaryColor;
  int accentColor;

  HarpyThemeData();

  factory HarpyThemeData.fromJson(Map<String, dynamic> json) =>
      _$HarpyThemeDataFromJson(json);

  Map<String, dynamic> toJson() => _$HarpyThemeDataToJson(this);
}
