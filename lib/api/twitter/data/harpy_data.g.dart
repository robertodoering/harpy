// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harpy_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HarpyData _$HarpyDataFromJson(Map<String, dynamic> json) {
  return HarpyData()
    ..showMedia = json['showMedia'] as bool
    ..translation = json['translation'] == null
        ? null
        : Translation.fromJson(json['translation'] as Map<String, dynamic>)
    ..parentOfReply = json['parentOfReply'] as bool
    ..childOfReply = json['childOfReply'] as bool;
}

Map<String, dynamic> _$HarpyDataToJson(HarpyData instance) => <String, dynamic>{
      'showMedia': instance.showMedia,
      'translation': instance.translation,
      'parentOfReply': instance.parentOfReply,
      'childOfReply': instance.childOfReply
    };
