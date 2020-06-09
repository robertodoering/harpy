// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hashtag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hashtag _$HashtagFromJson(Map<String, dynamic> json) {
  return Hashtag()
    ..text = json['text'] as String
    ..indices = (json['indices'] as List)?.map((e) => e as int)?.toList();
}

Map<String, dynamic> _$HashtagToJson(Hashtag instance) => <String, dynamic>{
      'text': instance.text,
      'indices': instance.indices,
    };
