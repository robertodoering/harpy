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
  int secondaryBackgroundColor;
  int likeColor;
  int retweetColor;

  HarpyThemeData();

  /// Sets all attributes to the [HarpyTheme] values if they are `null`.
  void fromTheme(HarpyTheme harpyTheme) {
    base ??= harpyTheme.base;
    primaryColor ??= harpyTheme.theme.primaryColor.value;
    accentColor ??= harpyTheme.theme.accentColor.value;
    scaffoldBackgroundColor ??= harpyTheme.theme.scaffoldBackgroundColor.value;
    secondaryBackgroundColor ??= harpyTheme.secondaryBackgroundColor.value;
    likeColor ??= harpyTheme.likeColor.value;
    retweetColor ??= harpyTheme.retweetColor.value;
  }

  @override
  bool operator ==(other) {
    if (other is HarpyThemeData) {
      return other.base == base &&
          other.name == name &&
          other.primaryColor == primaryColor &&
          other.accentColor == accentColor &&
          other.scaffoldBackgroundColor == scaffoldBackgroundColor &&
          other.likeColor == likeColor &&
          other.retweetColor == retweetColor;
    }
    return false;
  }

  factory HarpyThemeData.fromJson(Map<String, dynamic> json) =>
      _$HarpyThemeDataFromJson(json);

  Map<String, dynamic> toJson() => _$HarpyThemeDataToJson(this);

  @override
  String toString() {
    return 'HarpyThemeData{base: $base, name: $name, primaryColor: $primaryColor, accentColor: $accentColor, scaffoldBackgroundColor: $scaffoldBackgroundColor, secondaryBackgroundColor: $secondaryBackgroundColor, likeColor: $likeColor, retweetColor: $retweetColor}';
  }
}
