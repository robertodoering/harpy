// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Url _$UrlFromJson(Map<String, dynamic> json) {
  return Url(
      json['url'] as String,
      json['expanded_url'] as String,
      json['display_url'] as String,
      (json['indices'] as List)?.map((e) => e as int)?.toList());
}

Map<String, dynamic> _$UrlToJson(Url instance) => <String, dynamic>{
      'url': instance.url,
      'expanded_url': instance.expandedUrl,
      'display_url': instance.displayUrl,
      'indices': instance.indices
    };
