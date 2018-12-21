// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harpy_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HarpyData _$HarpyDataFromJson(Map<String, dynamic> json) {
  return HarpyData(
      json['show_media'] as bool,
      json['translation'] == null
          ? null
          : Translation.fromJson(json['translation'] as Map<String, dynamic>));
}

Map<String, dynamic> _$HarpyDataToJson(HarpyData instance) => <String, dynamic>{
      'show_media': instance.showMedia,
      'translation': instance.translation
    };
