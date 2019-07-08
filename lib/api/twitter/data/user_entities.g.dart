// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntities _$UserEntitiesFromJson(Map<String, dynamic> json) {
  return UserEntities()
    ..url = json['url'] == null
        ? null
        : UserEntityUrl.fromJson(json['url'] as Map<String, dynamic>)
    ..description = json['description'] == null
        ? null
        : UserEntityUrl.fromJson(json['description'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserEntitiesToJson(UserEntities instance) =>
    <String, dynamic>{'url': instance.url, 'description': instance.description};

UserEntityUrl _$UserEntityUrlFromJson(Map<String, dynamic> json) {
  return UserEntityUrl((json['urls'] as List)
      ?.map((e) => e == null ? null : Url.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$UserEntityUrlToJson(UserEntityUrl instance) =>
    <String, dynamic>{'urls': instance.urls};
