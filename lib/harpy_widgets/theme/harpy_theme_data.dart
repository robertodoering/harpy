import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:harpy/harpy_widgets/theme/harpy_theme.dart';
import 'package:json_annotation/json_annotation.dart';

part 'harpy_theme_data.g.dart';

@immutable
@JsonSerializable()
class HarpyThemeData {
  const HarpyThemeData({
    required this.name,
    required this.backgroundColors,
    required this.accentColor,
  });

  /// Creates a [HarpyThemeData] from a [HarpyTheme].
  HarpyThemeData.fromHarpyTheme(HarpyTheme harpyTheme)
      : name = harpyTheme.name,
        backgroundColors = harpyTheme.backgroundColors
            .map((Color? color) => color!.value)
            .toList(),
        accentColor = harpyTheme.accentColor.value;

  /// Creates a [HarpyThemeData] from a [HarpyThemeData].
  HarpyThemeData.from(HarpyThemeData other)
      : name = other.name,
        backgroundColors = List<int>.of(other.backgroundColors),
        accentColor = other.accentColor;

  factory HarpyThemeData.fromJson(Map<String, dynamic> json) =>
      _$HarpyThemeDataFromJson(json);

  /// The name for the theme.
  final String name;

  /// A list of background colors that create a background gradient.
  final List<int> backgroundColors;

  /// The accent color for the theme.
  final int accentColor;

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

  HarpyThemeData copyWith({
    String? name,
    List<int>? backgroundColors,
    int? accentColor,
  }) {
    return HarpyThemeData(
      name: name ?? this.name,
      backgroundColors: backgroundColors ?? this.backgroundColors,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}
