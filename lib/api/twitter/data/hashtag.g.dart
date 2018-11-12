// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hashtag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hashtag _$HashtagFromJson(Map<String, dynamic> json) {
  return Hashtag(json['text'] as String,
      (json['indices'] as List)?.map((e) => e as int)?.toList());
}

Map<String, dynamic> _$HashtagToJson(Hashtag instance) =>
    <String, dynamic>{'text': instance.text, 'indices': instance.indices};
