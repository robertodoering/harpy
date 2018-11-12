import 'package:harpy/api/twitter/data/hashtag.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/api/twitter/data/twitter_symbol.dart';
import 'package:harpy/api/twitter/data/url.dart';
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

  Entity(this.hashtags, this.symbols, this.urls, this.media);

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);

  Map<String, dynamic> toJson() => _$EntityToJson(this);
}
