import 'package:json_annotation/json_annotation.dart';

part 'twitter_symbol.g.dart';

@JsonSerializable()
class TwitterSymbol {
  @JsonKey(name: "text")
  String text;
  @JsonKey(name: "indices")
  List<int> indices;

  TwitterSymbol(this.text, this.indices);

  factory TwitterSymbol.fromJson(Map<String, dynamic> json) =>
      _$TwitterSymbolFromJson(json);

  Map<String, dynamic> toJson() => _$TwitterSymbolToJson(this);
}
