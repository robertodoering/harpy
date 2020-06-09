// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitter_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitterMedia _$TwitterMediaFromJson(Map<String, dynamic> json) {
  return TwitterMedia()
    ..id = json['id'] as int
    ..idStr = json['id_str'] as String
    ..indices = (json['indices'] as List)?.map((e) => e as int)?.toList()
    ..mediaUrl = json['media_url'] as String
    ..mediaUrlHttps = json['media_url_https'] as String
    ..url = json['url'] as String
    ..displayUrl = json['display_url'] as String
    ..expandedUrl = json['expanded_url'] as String
    ..type = json['type'] as String
    ..sizes = (json['sizes'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : MediaSize.fromJson(e as Map<String, dynamic>)),
    )
    ..videoInfo = json['video_info'] == null
        ? null
        : VideoInfo.fromJson(json['video_info'] as Map<String, dynamic>);
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
      'video_info': instance.videoInfo,
    };
