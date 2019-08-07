import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:json_annotation/json_annotation.dart';

part 'harpy_theme_data.g.dart';

@JsonSerializable()
class HarpyThemeData {
  HarpyThemeData();

  HarpyThemeData.fromHarpyTheme(HarpyTheme harpyTheme) {
    name = harpyTheme.name;
    backgroundColors =
        harpyTheme.backgroundColors.map((color) => color.value).toList();
    accentColor = harpyTheme.accentColor.value;
  }

  factory HarpyThemeData.fromJson(Map<String, dynamic> json) =>
      _$HarpyThemeDataFromJson(json);

  String name;

  List<int> backgroundColors;

  int accentColor;

  Map<String, dynamic> toJson() => _$HarpyThemeDataToJson(this);

  @override
  String toString() {
    return 'HarpyThemeData{name: $name,'
        'backgroundColors: $backgroundColors,'
        'accentColor: $accentColor}';
  }
}
