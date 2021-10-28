// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimelineFilter _$TimelineFilterFromJson(Map<String, dynamic> json) =>
    TimelineFilter(
      includesImages: json['includesImages'] as bool? ?? false,
      includesGif: json['includesGif'] as bool? ?? false,
      includesVideo: json['includesVideo'] as bool? ?? false,
      excludesHashtags: (json['excludesHashtags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      excludesPhrases: (json['excludesPhrases'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      excludesReplies: json['excludesReplies'] as bool? ?? false,
      excludesRetweets: json['excludesRetweets'] as bool? ?? false,
    );

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
