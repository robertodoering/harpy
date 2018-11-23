// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tweet _$TweetFromJson(Map<String, dynamic> json) {
  return Tweet(
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['entities'] == null
          ? null
          : Entities.fromJson(json['entities'] as Map<String, dynamic>),
      json['truncated'] as bool,
      json['created_at'] == null
          ? null
          : convertFromTwitterDateString(json['created_at'] as String),
      json['favorited'] as bool,
      json['id_str'] as String,
      json['in_reply_to_user_id_str'] as String,
      json['full_text'] as String,
      json['id'] as int,
      json['retweet_count'] as int,
      json['in_reply_to_status_id_str'] as String,
      json['retweeted'] as bool,
      json['source'] as String,
      json['favorite_count'] as int);
}

Map<String, dynamic> _$TweetToJson(Tweet instance) => <String, dynamic>{
      'user': instance.user,
      'entities': instance.entities,
      'truncated': instance.truncated,
      'created_at': instance.createdAt?.toIso8601String(),
      'favorited': instance.favorited,
      'id_str': instance.idStr,
      'in_reply_to_user_id_str': instance.inReplyToUserIdStr,
      'full_text': instance.full_text,
      'id': instance.id,
      'retweet_count': instance.retweetCount,
      'in_reply_to_status_id_str': instance.inReplyToStatusIdStr,
      'retweeted': instance.retweeted,
      'source': instance.source,
      'favorite_count': instance.favoriteCount
    };
