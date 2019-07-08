// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entities _$EntitiesFromJson(Map<String, dynamic> json) {
  return Entities()
    ..hashtags = (json['hashtags'] as List)
        ?.map((e) =>
            e == null ? null : Hashtag.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..symbols = (json['symbols'] as List)
        ?.map((e) => e == null
            ? null
            : TwitterSymbol.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..urls = (json['urls'] as List)
        ?.map((e) => e == null ? null : Url.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..media = (json['media'] as List)
        ?.map((e) =>
            e == null ? null : TwitterMedia.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..userMentions = (json['user_mentions'] as List)
        ?.map((e) =>
            e == null ? null : UserMention.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..polls = (json['polls'] as List)
        ?.map(
            (e) => e == null ? null : Poll.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$EntitiesToJson(Entities instance) => <String, dynamic>{
      'hashtags': instance.hashtags,
      'symbols': instance.symbols,
      'urls': instance.urls,
      'media': instance.media,
      'user_mentions': instance.userMentions,
      'polls': instance.polls
    };
