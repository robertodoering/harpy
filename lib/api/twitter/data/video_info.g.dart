// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoInfo _$VideoInfoFromJson(Map<String, dynamic> json) {
  return VideoInfo()
    ..aspectRatio =
        (json['aspect_ratio'] as List)?.map((e) => e as int)?.toList()
    ..durationMillis = json['duration_millis'] as int
    ..variants = (json['variants'] as List)
        ?.map((e) =>
            e == null ? null : Variants.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$VideoInfoToJson(VideoInfo instance) => <String, dynamic>{
      'aspect_ratio': instance.aspectRatio,
      'duration_millis': instance.durationMillis,
      'variants': instance.variants,
    };

Variants _$VariantsFromJson(Map<String, dynamic> json) {
  return Variants()
    ..bitrate = json['bitrate'] as int
    ..contentType = json['content_type'] as String
    ..url = json['url'] as String;
}

Map<String, dynamic> _$VariantsToJson(Variants instance) => <String, dynamic>{
      'bitrate': instance.bitrate,
      'content_type': instance.contentType,
      'url': instance.url,
    };
