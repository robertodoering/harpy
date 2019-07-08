// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tweet _$TweetFromJson(Map<String, dynamic> json) {
  return Tweet()
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..entities = json['entities'] == null
        ? null
        : Entities.fromJson(json['entities'] as Map<String, dynamic>)
    ..extendedEntities = json['extended_entities'] == null
        ? null
        : Entities.fromJson(json['extended_entities'] as Map<String, dynamic>)
    ..truncated = json['truncated'] as bool
    ..createdAt = convertFromTwitterDateString(json['created_at'] as String)
    ..favorited = json['favorited'] as bool
    ..idStr = json['id_str'] as String
    ..inReplyToUserIdStr = json['in_reply_to_user_id_str'] as String
    ..fullText = json['full_text'] as String
    ..id = json['id'] as int
    ..retweetCount = json['retweet_count'] as int
    ..inReplyToStatusIdStr = json['in_reply_to_status_id_str'] as String
    ..retweeted = json['retweeted'] as bool
    ..source = json['source'] as String
    ..favoriteCount = json['favorite_count'] as int
    ..retweetedStatus = json['retweeted_status'] == null
        ? null
        : Tweet.fromJson(json['retweeted_status'] as Map<String, dynamic>)
    ..lang = json['lang'] as String
    ..displayTextRange =
        (json['display_text_range'] as List)?.map((e) => e as int)?.toList()
    ..quotedStatus = json['quoted_status'] == null
        ? null
        : Tweet.fromJson(json['quoted_status'] as Map<String, dynamic>)
    ..quotedStatusPermalink = json['quoted_status_permalink'] == null
        ? null
        : QuotedStatusPermalink.fromJson(
            json['quoted_status_permalink'] as Map<String, dynamic>)
    ..harpyData = harpyDataFromJson(json['harpyData'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TweetToJson(Tweet instance) => <String, dynamic>{
      'user': instance.user,
      'entities': instance.entities,
      'extended_entities': instance.extendedEntities,
      'truncated': instance.truncated,
      'created_at': instance.createdAt?.toIso8601String(),
      'favorited': instance.favorited,
      'id_str': instance.idStr,
      'in_reply_to_user_id_str': instance.inReplyToUserIdStr,
      'full_text': instance.fullText,
      'id': instance.id,
      'retweet_count': instance.retweetCount,
      'in_reply_to_status_id_str': instance.inReplyToStatusIdStr,
      'retweeted': instance.retweeted,
      'source': instance.source,
      'favorite_count': instance.favoriteCount,
      'retweeted_status': instance.retweetedStatus,
      'lang': instance.lang,
      'display_text_range': instance.displayTextRange,
      'quoted_status': instance.quotedStatus,
      'quoted_status_permalink': instance.quotedStatusPermalink,
      'harpyData': instance.harpyData
    };
