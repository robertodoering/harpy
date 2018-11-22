import 'package:harpy/api/twitter/data/hashtag.dart';
import 'package:harpy/api/twitter/data/poll.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/api/twitter/data/twitter_symbol.dart';
import 'package:harpy/api/twitter/data/url.dart';
import 'package:harpy/api/twitter/data/user_mention.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

@JsonSerializable()
class Entity {
  @JsonKey(name: "hashtags")
  List<Hashtag> hashtags;
  @JsonKey(name: "symbols")
  List<TwitterSymbol> symbols;
  @JsonKey(name: "urls")
  List<Url> urls;
  @JsonKey(name: "media")
  List<TwitterMedia> media;
  @JsonKey(name: "user_mentions")
  List<UserMention> userMentions;
  @JsonKey(name: "polls")
  List<Poll> polls;

  Entity(this.hashtags, this.symbols, this.urls, this.media, this.userMentions,
      this.polls);

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);

  Map<String, dynamic> toJson() => _$EntityToJson(this);

  @override
  String toString() {
    return 'Entity{hashtags: $hashtags,\n'
        'symbols: $symbols,\n'
        'urls: $urls,\n'
        'media: $media,\n'
        'userMentions: $userMentions,\n'
        'polls: $polls}';
  }
}
