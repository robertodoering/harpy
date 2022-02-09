import 'package:built_collection/built_collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/rby/rby.dart';

part 'harpy_theme_data.freezed.dart';
part 'harpy_theme_data.g.dart';

@freezed
class HarpyThemeData with _$HarpyThemeData {
  const factory HarpyThemeData({
    required String name,
    @BuiltListIntConverter() required BuiltList<int> backgroundColors,
    required int primaryColor,
    required int secondaryColor,
    required int cardColor,
    required int statusBarColor,
    required int navBarColor,
  }) = _HarpyThemeData;

  factory HarpyThemeData.fromJson(Map<String, dynamic> json) =>
      _$HarpyThemeDataFromJson(json);
}
