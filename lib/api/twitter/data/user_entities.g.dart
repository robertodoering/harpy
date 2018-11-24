// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntities _$UserEntitiesFromJson(Map<String, dynamic> json) {
  return UserEntities(
      (json['url'] as List)
          ?.map(
              (e) => e == null ? null : Url.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['description'] as List)
          ?.map(
              (e) => e == null ? null : Url.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$UserEntitiesToJson(UserEntities instance) =>
    <String, dynamic>{'url': instance.url, 'description': instance.description};
