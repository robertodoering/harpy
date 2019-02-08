// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harpy_theme_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HarpyThemeData _$HarpyThemeDataFromJson(Map<String, dynamic> json) {
  return HarpyThemeData()
    ..base = json['base'] as String
    ..name = json['name'] as String
    ..primaryColor = json['primaryColor'] as int
    ..accentColor = json['accentColor'] as int
    ..scaffoldBackgroundColor = json['scaffoldBackgroundColor'] as int
    ..secondaryBackgroundColor = json['secondaryBackgroundColor'] as int
    ..likeColor = json['likeColor'] as int
    ..retweetColor = json['retweetColor'] as int;
}

Map<String, dynamic> _$HarpyThemeDataToJson(HarpyThemeData instance) =>
    <String, dynamic>{
      'base': instance.base,
      'name': instance.name,
      'primaryColor': instance.primaryColor,
      'accentColor': instance.accentColor,
      'scaffoldBackgroundColor': instance.scaffoldBackgroundColor,
      'secondaryBackgroundColor': instance.secondaryBackgroundColor,
      'likeColor': instance.likeColor,
      'retweetColor': instance.retweetColor
    };
