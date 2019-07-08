import 'package:harpy/api/twitter/data/hashtag.dart';
import 'package:harpy/api/twitter/data/poll.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/api/twitter/data/twitter_symbol.dart';
import 'package:harpy/api/twitter/data/url.dart';
import 'package:harpy/api/twitter/data/user_mention.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entities.g.dart';

@JsonSerializable()
class Entities {
  Entities();

  factory Entities.fromJson(Map<String, dynamic> json) =>
      _$EntitiesFromJson(json);

  List<Hashtag> hashtags;
  List<TwitterSymbol> symbols;
  List<Url> urls;
  List<TwitterMedia> media;
  @JsonKey(name: "user_mentions")
  List<UserMention> userMentions;
  List<Poll> polls;

  Map<String, dynamic> toJson() => _$EntitiesToJson(this);
}
