// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitter_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitterMedia _$TwitterMediaFromJson(Map<String, dynamic> json) {
  return TwitterMedia(
      json['id'] as int,
      json['id_str'] as String,
      (json['indices'] as List)?.map((e) => e as int)?.toList(),
      json['media_url'] as String,
      json['media_url_https'] as String,
      json['url'] as String,
      json['display_url'] as String,
      json['expanded_url'] as String,
      json['type'] as String,
      (json['sizes'] as Map<String, dynamic>)?.map((k, e) => MapEntry(
          k, e == null ? null : MediaSize.fromJson(e as Map<String, dynamic>))),
      json['video_info'] == null
          ? null
          : VideoInfo.fromJson(json['video_info'] as Map<String, dynamic>));
}

Map<String, dynamic> _$TwitterMediaToJson(TwitterMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_str': instance.idStr,
      'indices': instance.indices,
      'media_url': instance.mediaUrl,
      'media_url_https': instance.mediaUrlHttps,
      'url': instance.url,
      'display_url': instance.displayUrl,
      'expanded_url': instance.expandedUrl,
      'type': instance.type,
      'sizes': instance.sizes,
      'video_info': instance.videoInfo
    };
