// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_tab_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeTabEntry _$HomeTabEntryFromJson(Map<String, dynamic> json) {
  return HomeTabEntry(
    id: json['id'] as String,
    type: json['type'] as String,
    icon: json['icon'] as String,
    name: json['name'] as String,
    visible: json['visible'] as bool,
  );
}

Map<String, dynamic> _$HomeTabEntryToJson(HomeTabEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'icon': instance.icon,
      'name': instance.name,
      'visible': instance.visible,
    };
