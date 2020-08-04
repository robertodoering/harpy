import 'package:json_annotation/json_annotation.dart';

part 'harpy_theme_data.g.dart';

@JsonSerializable()
class HarpyThemeData {
  HarpyThemeData();

  factory HarpyThemeData.fromJson(Map<String, dynamic> json) =>
      _$HarpyThemeDataFromJson(json);

  /// The name for the theme.
  String name;

  /// A list of background colors that create a background gradient.
  List<int> backgroundColors;

  /// The accent color for the theme.
  int accentColor;

  Map<String, dynamic> toJson() => _$HarpyThemeDataToJson(this);
}
