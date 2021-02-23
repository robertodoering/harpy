// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimelineFilter _$TimelineFilterFromJson(Map<String, dynamic> json) {
  return TimelineFilter(
    includesImages: json['includesImages'] as bool,
    includesGif: json['includesGif'] as bool,
    includesVideo: json['includesVideo'] as bool,
    excludesHashtags:
        (json['excludesHashtags'] as List)?.map((e) => e as String)?.toList(),
    excludesPhrases:
        (json['excludesPhrases'] as List)?.map((e) => e as String)?.toList(),
    excludesReplies: json['excludesReplies'] as bool,
    excludesRetweets: json['excludesRetweets'] as bool,
  );
}

Map<String, dynamic> _$TimelineFilterToJson(TimelineFilter instance) =>
    <String, dynamic>{
      'includesImages': instance.includesImages,
      'includesGif': instance.includesGif,
      'includesVideo': instance.includesVideo,
      'excludesHashtags': instance.excludesHashtags,
      'excludesPhrases': instance.excludesPhrases,
      'excludesReplies': instance.excludesReplies,
      'excludesRetweets': instance.excludesRetweets,
    };
