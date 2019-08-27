// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TweetSearch _$TweetSearchFromJson(Map<String, dynamic> json) {
  return TweetSearch()
    ..statuses = (json['statuses'] as List)
        ?.map(
            (e) => e == null ? null : Tweet.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..searchMetadata = json['search_metadata'] == null
        ? null
        : SearchMetadata.fromJson(
            json['search_metadata'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TweetSearchToJson(TweetSearch instance) =>
    <String, dynamic>{
      'statuses': instance.statuses,
      'search_metadata': instance.searchMetadata,
    };

SearchMetadata _$SearchMetadataFromJson(Map<String, dynamic> json) {
  return SearchMetadata()
    ..completedIn = (json['completed_in'] as num)?.toDouble()
    ..maxId = json['max_id'] as int
    ..maxIdStr = json['max_id_str'] as String
    ..nextResults = json['next_results'] as String
    ..query = json['query'] as String
    ..refreshUrl = json['refresh_url'] as String
    ..count = json['count'] as int
    ..sinceId = json['since_id'] as int
    ..sinceIdStr = json['since_id_str'] as String;
}

Map<String, dynamic> _$SearchMetadataToJson(SearchMetadata instance) =>
    <String, dynamic>{
      'completed_in': instance.completedIn,
      'max_id': instance.maxId,
      'max_id_str': instance.maxIdStr,
      'next_results': instance.nextResults,
      'query': instance.query,
      'refresh_url': instance.refreshUrl,
      'count': instance.count,
      'since_id': instance.sinceId,
      'since_id_str': instance.sinceIdStr,
    };
