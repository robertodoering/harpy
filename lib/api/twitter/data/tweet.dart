import 'package:harpy/api/twitter/data/entities.dart';
import 'package:harpy/api/twitter/data/extended_tweet.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/utils/date_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tweet.g.dart';

@JsonSerializable()
class Tweet {
  @JsonKey(name: 'user')
  User user;
  @JsonKey(name: 'entities')
  Entities entity;
  @JsonKey(name: 'truncated')
  bool truncated;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'favorited')
  bool favorited;
  @JsonKey(name: 'id_str')
  String idStr;
  @JsonKey(name: 'in_reply_to_user_id_str')
  String inReplyToUserIdStr;
  @JsonKey(name: 'text')
  String text;
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'retweet_count')
  int retweetCount;
  @JsonKey(name: 'in_reply_to_status_id_str')
  String inReplyToStatusIdStr;
  @JsonKey(name: 'retweeted')
  bool retweeted;
  @JsonKey(name: 'source')
  String source;
  @JsonKey(name: "favorite_count")
  int favoriteCount;
  @JsonKey(name: 'extended_tweet')
  ExtendedTweet extendedTweet;

  Tweet(
    this.user,
    this.entity,
    this.truncated,
    this.createdAt,
    this.favorited,
    this.idStr,
    this.inReplyToUserIdStr,
    this.text,
    this.id,
    this.retweetCount,
    this.inReplyToStatusIdStr,
    this.retweeted,
    this.source,
    this.favoriteCount,
    this.extendedTweet,
  );

  factory Tweet.fromJson(Map<String, dynamic> json) => _$TweetFromJson(json);

  Map<String, dynamic> toJson() => _$TweetToJson(this);

  @override
  String toString() {
    return 'Tweet{user: $user, entity: $entity, truncated: $truncated, createdAt: $createdAt, favorited: $favorited, idStr: $idStr, inReplyToUserIdStr: $inReplyToUserIdStr, text: $text, id: $id, retweetCount: $retweetCount, inReplyToStatusIdStr: $inReplyToStatusIdStr, retweeted: $retweeted, source: $source, favoriteCount: $favoriteCount, extendedTweet: $extendedTweet}';
  }
}
