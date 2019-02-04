import 'package:harpy/core/misc/theme.dart';
import 'package:json_annotation/json_annotation.dart';

part 'harpy_theme_data.g.dart';

@JsonSerializable()
class HarpyThemeData {
  String base;
  String name;
  int primaryColor;
  int accentColor;

  HarpyThemeData();

  HarpyThemeData.fromTheme(HarpyTheme harpyTheme) {
    base = harpyTheme.base;
    primaryColor = harpyTheme.primaryColor?.value;
    accentColor = harpyTheme.accentColor?.value;
  }

  factory HarpyThemeData.fromJson(Map<String, dynamic> json) =>
      _$HarpyThemeDataFromJson(json);

  Map<String, dynamic> toJson() => _$HarpyThemeDataToJson(this);
}
