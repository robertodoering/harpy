import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tweet_search.g.dart';

@JsonSerializable()
class TweetSearch {
  TweetSearch();

  factory TweetSearch.fromJson(Map<String, dynamic> json) =>
      _$TweetSearchFromJson(json);

  List<Tweet> statuses;
  @JsonKey(name: "search_metadata")
  SearchMetadata searchMetadata;

  Map<String, dynamic> toJson() => _$TweetSearchToJson(this);
}

@JsonSerializable()
class SearchMetadata {
  SearchMetadata();

  factory SearchMetadata.fromJson(Map<String, dynamic> json) =>
      _$SearchMetadataFromJson(json);

  @JsonKey(name: "completed_in")
  double completedIn;
  @JsonKey(name: "max_id")
  int maxId;
  @JsonKey(name: "max_id_str")
  String maxIdStr;
  @JsonKey(name: "next_results")
  String nextResults;
  String query;
  @JsonKey(name: "refresh_url")
  String refreshUrl;
  int count;
  @JsonKey(name: "since_id")
  int sinceId;
  @JsonKey(name: "since_id_str")
  String sinceIdStr;

  Map<String, dynamic> toJson() => _$SearchMetadataToJson(this);
}
