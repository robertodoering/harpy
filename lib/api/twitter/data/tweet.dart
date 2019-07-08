import 'package:harpy/api/twitter/data/entities.dart';
import 'package:harpy/api/twitter/data/harpy_data.dart';
import 'package:harpy/api/twitter/data/quoted_status_permalink.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/utils/date_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tweet.g.dart';

@JsonSerializable()
class Tweet {
  Tweet();

  factory Tweet.fromJson(Map<String, dynamic> json) => _$TweetFromJson(json);

  User user;
  Entities entities;
  @JsonKey(name: "extended_entities")
  Entities extendedEntities;
  bool truncated;
  @JsonKey(name: "created_at", fromJson: convertFromTwitterDateString)
  DateTime createdAt;
  bool favorited;
  @JsonKey(name: "id_str")
  String idStr;
  @JsonKey(name: "in_reply_to_user_id_str")
  String inReplyToUserIdStr;
  @JsonKey(name: "full_text")
  String fullText;
  int id;
  @JsonKey(name: "retweet_count")
  int retweetCount;
  @JsonKey(name: "in_reply_to_status_id_str")
  String inReplyToStatusIdStr;
  bool retweeted;
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
  @JsonKey(name: "quoted_status_permalink")
  QuotedStatusPermalink quotedStatusPermalink;

  // custom data
  @JsonKey(fromJson: harpyDataFromJson)
  HarpyData harpyData;

  bool get emptyText => displayTextRange[1] == 0;

  Map<String, dynamic> toJson() => _$TweetToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tweet && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

HarpyData harpyDataFromJson(Map<String, dynamic> json) {
  return json == null ? HarpyData() : HarpyData.fromJson(json);
}
