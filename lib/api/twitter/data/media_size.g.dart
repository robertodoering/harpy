// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_size.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaSize _$MediaSizeFromJson(Map<String, dynamic> json) {
  return MediaSize(
      json['w'] as int, json['h'] as int, json['resize'] as String);
}

Map<String, dynamic> _$MediaSizeToJson(MediaSize instance) => <String, dynamic>{
      'w': instance.w,
      'h': instance.h,
      'resize': instance.resize
    };
