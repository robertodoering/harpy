// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_mention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMention _$UserMentionFromJson(Map<String, dynamic> json) {
  return UserMention(
      json['screen_name'] as String,
      json['name'] as String,
      json['id'] as int,
      json['id_str'] as String,
      (json['indices'] as List)?.map((e) => e as int)?.toList());
}

Map<String, dynamic> _$UserMentionToJson(UserMention instance) =>
    <String, dynamic>{
      'screen_name': instance.screenName,
      'name': instance.name,
      'id': instance.id,
      'id_str': instance.idStr,
      'indices': instance.indices
    };
