// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Poll _$PollFromJson(Map<String, dynamic> json) {
  return Poll(
      json['end_datetime'] == null
          ? null
          : convertFromTwitterDateString(json['end_datetime'] as String),
      json['duration_minutes'] as int,
      (json['options'] as List)
          ?.map((e) =>
              e == null ? null : PollOption.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$PollToJson(Poll instance) => <String, dynamic>{
      'end_datetime': instance.endDatetime?.toIso8601String(),
      'duration_minutes': instance.duration,
      'options': instance.pollOptions
    };
