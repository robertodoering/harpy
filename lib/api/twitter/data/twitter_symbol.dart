import 'package:json_annotation/json_annotation.dart';

part 'twitter_symbol.g.dart';

@JsonSerializable()
class TwitterSymbol {
  TwitterSymbol();

  factory TwitterSymbol.fromJson(Map<String, dynamic> json) =>
      _$TwitterSymbolFromJson(json);

  String text;
  List<int> indices;

  Map<String, dynamic> toJson() => _$TwitterSymbolToJson(this);
}
