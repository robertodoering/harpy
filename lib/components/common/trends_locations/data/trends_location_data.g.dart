// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trends_location_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendsLocationData _$TrendsLocationDataFromJson(Map<String, dynamic> json) =>
    TrendsLocationData(
      name: json['name'] as String,
      woeid: json['woeid'] as int,
      placeType: json['placeType'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$TrendsLocationDataToJson(TrendsLocationData instance) =>
    <String, dynamic>{
      'woeid': instance.woeid,
      'name': instance.name,
      'placeType': instance.placeType,
      'country': instance.country,
    };
