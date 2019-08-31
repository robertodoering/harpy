// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Url _$UrlFromJson(Map<String, dynamic> json) {
  return Url()
    ..url = json['url'] as String
    ..expandedUrl = json['expanded_url'] as String
    ..displayUrl = json['display_url'] as String
    ..indices = (json['indices'] as List)?.map((e) => e as int)?.toList();
}

Map<String, dynamic> _$UrlToJson(Url instance) => <String, dynamic>{
      'url': instance.url,
      'expanded_url': instance.expandedUrl,
      'display_url': instance.displayUrl,
      'indices': instance.indices,
    };
