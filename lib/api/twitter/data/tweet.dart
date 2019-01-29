import 'package:harpy/api/twitter/data/entities.dart';
import 'package:harpy/api/twitter/data/harpy_data.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/utils/date_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tweet.g.dart';

@JsonSerializable()
class Tweet {
  @JsonKey(name: 'user')
  User user;
  @JsonKey(name: 'entities')
  Entities entities;
  @JsonKey(name: 'extended_entities')
  Entities extended_entities;
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
  @JsonKey(name: 'full_text')
  String full_text;
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
  @JsonKey(name: "retweeted_status")
  Tweet retweetedStatus;
  String lang;
  @JsonKey(name: "display_text_range")
  List<int> displayTextRange;
  @JsonKey(name: "quoted_status")
  Tweet quotedStatus;

  // custom data
  @JsonKey(name: "harpy_data")
  HarpyData harpyData;

  bool get emptyText => displayTextRange[1] == 0;

  Tweet(
    this.user,
    this.entities,
    this.truncated,
    this.createdAt,
    this.favorited,
    this.idStr,
    this.inReplyToUserIdStr,
    this.full_text,
    this.id,
    this.retweetCount,
    this.inReplyToStatusIdStr,
    this.retweeted,
    this.source,
    this.favoriteCount,
    this.retweetedStatus,
    this.lang,
    this.harpyData,
    this.displayTextRange,
  );

  factory Tweet.mock() {
    return Tweet(
      User.mock(),
      Entities(null, null, null, null, null, null),
      false,
      DateTime.parse("2018-07-29"),
      true,
      null,
      null,
      "Today is a good day.",
      null,
      69,
      null,
      false,
      null,
      420,
      null,
      "en",
      HarpyData.init(),
      [0, 1],
    );
  }

  factory Tweet.fromJson(Map<String, dynamic> json) => _$TweetFromJson(json);

  Map<String, dynamic> toJson() => _$TweetToJson(this);

  @override
  String toString() {
    return 'Tweet{user: $user, entities: $entities, truncated: $truncated, createdAt: $createdAt, favorited: $favorited, idStr: $idStr, inReplyToUserIdStr: $inReplyToUserIdStr, full_text: $full_text, id: $id, retweetCount: $retweetCount, inReplyToStatusIdStr: $inReplyToStatusIdStr, retweeted: $retweeted, source: $source, favoriteCount: $favoriteCount}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tweet && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
