// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harpy_theme_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HarpyThemeData _$HarpyThemeDataFromJson(Map<String, dynamic> json) {
  return HarpyThemeData()
    ..base = json['base'] as String
    ..name = json['name'] as String
    ..accentColor = json['accentColor'] as int
    ..primaryBackgroundColor = json['primaryBackgroundColor'] as int
    ..secondaryBackgroundColor = json['secondaryBackgroundColor'] as int
    ..likeColor = json['likeColor'] as int
    ..retweetColor = json['retweetColor'] as int;
}

Map<String, dynamic> _$HarpyThemeDataToJson(HarpyThemeData instance) =>
    <String, dynamic>{
      'base': instance.base,
      'name': instance.name,
      'accentColor': instance.accentColor,
      'primaryBackgroundColor': instance.primaryBackgroundColor,
      'secondaryBackgroundColor': instance.secondaryBackgroundColor,
      'likeColor': instance.likeColor,
      'retweetColor': instance.retweetColor
    };
