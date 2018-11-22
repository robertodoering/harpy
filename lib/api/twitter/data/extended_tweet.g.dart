// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extended_tweet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtendedTweet _$ExtendedTweetFromJson(Map<String, dynamic> json) {
  return ExtendedTweet(
      json['full_text'] as String,
      json['entities'] == null
          ? null
          : Entities.fromJson(json['entities'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ExtendedTweetToJson(ExtendedTweet instance) =>
    <String, dynamic>{
      'full_text': instance.full_text,
      'entities': instance.entities
    };
