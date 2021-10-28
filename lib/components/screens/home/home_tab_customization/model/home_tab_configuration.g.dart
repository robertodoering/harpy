// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_tab_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeTabConfiguration _$HomeTabConfigurationFromJson(
        Map<String, dynamic> json) =>
    HomeTabConfiguration(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => HomeTabEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeTabConfigurationToJson(
        HomeTabConfiguration instance) =>
    <String, dynamic>{
      'entries': instance.entries.map((e) => e.toJson()).toList(),
    };
