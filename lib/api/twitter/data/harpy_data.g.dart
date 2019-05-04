// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harpy_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HarpyData _$HarpyDataFromJson(Map<String, dynamic> json) {
  return HarpyData(
      json['showMedia'] as bool,
      json['translation'] == null
          ? null
          : Translation.fromJson(json['translation'] as Map<String, dynamic>),
      json['parentOfReply'] as bool,
      json['childOfReply'] as bool);
}

Map<String, dynamic> _$HarpyDataToJson(HarpyData instance) => <String, dynamic>{
      'showMedia': instance.showMedia,
      'translation': instance.translation,
      'parentOfReply': instance.parentOfReply,
      'childOfReply': instance.childOfReply,
    };
