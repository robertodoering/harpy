// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollOption _$PollOptionFromJson(Map<String, dynamic> json) {
  return PollOption()
    ..position = json['position'] as int
    ..text = json['text'] as String;
}

Map<String, dynamic> _$PollOptionToJson(PollOption instance) =>
    <String, dynamic>{
      'position': instance.position,
      'text': instance.text,
    };
