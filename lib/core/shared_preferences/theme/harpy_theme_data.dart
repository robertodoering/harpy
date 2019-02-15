import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:json_annotation/json_annotation.dart';

part 'harpy_theme_data.g.dart';

@JsonSerializable()
class HarpyThemeData {
  HarpyThemeData();

  String base;
  String name;

  int accentColor;

  int primaryBackgroundColor;
  int secondaryBackgroundColor;

  int likeColor;
  int retweetColor;

  /// Sets all attributes to the [HarpyTheme] values if they are `null`.
  void fromTheme(HarpyTheme harpyTheme) {
    base ??= harpyTheme.base;
    accentColor ??= harpyTheme.theme.accentColor.value;
    primaryBackgroundColor ??= harpyTheme.primaryBackgroundColor.value;
    secondaryBackgroundColor ??= harpyTheme.secondaryBackgroundColor.value;
    likeColor ??= harpyTheme.likeColor.value;
    retweetColor ??= harpyTheme.retweetColor.value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HarpyThemeData &&
          runtimeType == other.runtimeType &&
          base == other.base &&
          name == other.name &&
          accentColor == other.accentColor &&
          primaryBackgroundColor == other.primaryBackgroundColor &&
          secondaryBackgroundColor == other.secondaryBackgroundColor &&
          likeColor == other.likeColor &&
          retweetColor == other.retweetColor;

  @override
  int get hashCode =>
      base.hashCode ^
      name.hashCode ^
      accentColor.hashCode ^
      primaryBackgroundColor.hashCode ^
      secondaryBackgroundColor.hashCode ^
      likeColor.hashCode ^
      retweetColor.hashCode;

  factory HarpyThemeData.fromJson(Map<String, dynamic> json) =>
      _$HarpyThemeDataFromJson(json);

  Map<String, dynamic> toJson() => _$HarpyThemeDataToJson(this);

  @override
  String toString() {
    return 'HarpyThemeData{base: $base, name: $name, accentColor: $accentColor, backgroundColor1: $primaryBackgroundColor, backgroundColor2: $secondaryBackgroundColor, likeColor: $likeColor, retweetColor: $retweetColor}';
  }
}
