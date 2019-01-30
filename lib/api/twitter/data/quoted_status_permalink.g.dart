// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quoted_status_permalink.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuotedStatusPermalink _$QuotedStatusPermalinkFromJson(
    Map<String, dynamic> json) {
  return QuotedStatusPermalink()
    ..url = json['url'] as String
    ..expanded = json['expanded'] as String
    ..display = json['display'] as String;
}

Map<String, dynamic> _$QuotedStatusPermalinkToJson(
        QuotedStatusPermalink instance) =>
    <String, dynamic>{
      'url': instance.url,
      'expanded': instance.expanded,
      'display': instance.display
    };
