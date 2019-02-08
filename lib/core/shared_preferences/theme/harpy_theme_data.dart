import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:json_annotation/json_annotation.dart';

part 'harpy_theme_data.g.dart';

@JsonSerializable()
class HarpyThemeData {
  String base;
  String name;
  int primaryColor;
  int accentColor;
  int scaffoldBackgroundColor;

  HarpyThemeData();

  HarpyThemeData.fromTheme(HarpyTheme harpyTheme) {
    base = harpyTheme.base;
    primaryColor = harpyTheme.theme.primaryColor.value;
    accentColor = harpyTheme.theme.accentColor.value;
    scaffoldBackgroundColor = harpyTheme.theme.scaffoldBackgroundColor.value;
  }

  @override
  bool operator ==(other) {
    if (other is HarpyThemeData) {
      return other.base == base &&
          other.name == name &&
          other.primaryColor == primaryColor &&
          other.accentColor == accentColor &&
          other.scaffoldBackgroundColor == scaffoldBackgroundColor;
    }
    return false;
  }

  factory HarpyThemeData.fromJson(Map<String, dynamic> json) =>
      _$HarpyThemeDataFromJson(json);

  Map<String, dynamic> toJson() => _$HarpyThemeDataToJson(this);
}
