// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harpy_theme_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HarpyThemeData _$HarpyThemeDataFromJson(Map<String, dynamic> json) {
  return HarpyThemeData()
    ..name = json['name'] as String
    ..backgroundColors =
        (json['backgroundColors'] as List)?.map((e) => e as int)?.toList()
    ..accentColor = json['accentColor'] as int;
}

Map<String, dynamic> _$HarpyThemeDataToJson(HarpyThemeData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'backgroundColors': instance.backgroundColors,
      'accentColor': instance.accentColor,
    };
