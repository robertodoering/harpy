import 'package:json_annotation/json_annotation.dart';

part 'twitter_symbol.g.dart';

@JsonSerializable()
class TwitterSymbol {
  TwitterSymbol(this.text, this.indices);

  factory TwitterSymbol.fromJson(Map<String, dynamic> json) =>
      _$TwitterSymbolFromJson(json);

  @JsonKey(name: "text")
  String text;
  @JsonKey(name: "indices")
  List<int> indices;

  Map<String, dynamic> toJson() => _$TwitterSymbolToJson(this);

  @override
  String toString() {
    return 'TwitterSymbol{text: $text, indices: $indices}';
  }
}
