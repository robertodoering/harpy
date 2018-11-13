// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entity _$EntityFromJson(Map<String, dynamic> json) {
  return Entity(
      (json['hashtags'] as List)
          ?.map((e) =>
              e == null ? null : Hashtag.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['symbols'] as List)
          ?.map((e) => e == null
              ? null
              : TwitterSymbol.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['urls'] as List)
          ?.map(
              (e) => e == null ? null : Url.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['media'] as List)
          ?.map((e) => e == null
              ? null
              : TwitterMedia.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['user_mentions'] as List)
          ?.map((e) => e == null
              ? null
              : UserMention.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['polls'] as List)
          ?.map((e) =>
              e == null ? null : Poll.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$EntityToJson(Entity instance) => <String, dynamic>{
      'hashtags': instance.hashtags,
      'symbols': instance.symbols,
      'urls': instance.urls,
      'media': instance.media,
      'user_mentions': instance.userMentions,
      'polls': instance.polls
    };
