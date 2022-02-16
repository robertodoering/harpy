import 'package:freezed_annotation/freezed_annotation.dart';

part 'harpy_theme_data.freezed.dart';
part 'harpy_theme_data.g.dart';

@freezed
class HarpyThemeData with _$HarpyThemeData {
  const factory HarpyThemeData({
    required String name,
    required List<int> backgroundColors,
    required int primaryColor,
    required int secondaryColor,
    required int cardColor,
    required int statusBarColor,
    required int navBarColor,
  }) = _HarpyThemeData;

  factory HarpyThemeData.fromJson(Map<String, dynamic> json) =>
      _$HarpyThemeDataFromJson(json);
}
