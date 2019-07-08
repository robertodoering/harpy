// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitter_symbol.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwitterSymbol _$TwitterSymbolFromJson(Map<String, dynamic> json) {
  return TwitterSymbol()
    ..text = json['text'] as String
    ..indices = (json['indices'] as List)?.map((e) => e as int)?.toList();
}

Map<String, dynamic> _$TwitterSymbolToJson(TwitterSymbol instance) =>
    <String, dynamic>{'text': instance.text, 'indices': instance.indices};
