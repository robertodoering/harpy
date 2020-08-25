import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:json_annotation/json_annotation.dart';

part 'harpy_theme_data.g.dart';

@JsonSerializable()
class HarpyThemeData {
  HarpyThemeData();

  /// Creates a [HarpyThemeData] from a [HarpyTheme].
  HarpyThemeData.fromHarpyTheme(HarpyTheme harpyTheme) {
    name = harpyTheme.name;
    backgroundColors =
        harpyTheme.backgroundColors.map((Color color) => color.value).toList();
    accentColor = harpyTheme.accentColor.value;
  }

  factory HarpyThemeData.fromJson(Map<String, dynamic> json) =>
      _$HarpyThemeDataFromJson(json);

  /// The name for the theme.
  String name;

  /// A list of background colors that create a background gradient.
  List<int> backgroundColors;

  /// The accent color for the theme.
  int accentColor;

  @override
  bool operator ==(dynamic other) {
    return other is HarpyThemeData &&
        other.name == name &&
        listEquals(other.backgroundColors, backgroundColors) &&
        other.accentColor == accentColor;
  }

  @override
  int get hashCode => hashValues(name, hashList(backgroundColors), accentColor);

  Map<String, dynamic> toJson() => _$HarpyThemeDataToJson(this);
}
