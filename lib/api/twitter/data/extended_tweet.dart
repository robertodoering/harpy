import 'package:harpy/api/twitter/data/entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'extended_tweet.g.dart';

@JsonSerializable()
class ExtendedTweet {
  @JsonKey(name: 'full_text')
  String full_text;

  @JsonKey(name: 'entities')
  Entities entities;

  ExtendedTweet(
    this.full_text,
    this.entities,
  );

  factory ExtendedTweet.fromJson(Map<String, dynamic> json) =>
      _$ExtendedTweetFromJson(json);
}
