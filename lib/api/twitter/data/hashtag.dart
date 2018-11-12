import 'package:json_annotation/json_annotation.dart';

part 'hashtag.g.dart';

@JsonSerializable()
class Hashtag {
  @JsonKey(name: "text")
  String text;
  @JsonKey(name: "indices")
  List<int> indices;

  Hashtag(this.text, this.indices);

  factory Hashtag.fromJson(Map<String, dynamic> json) =>
      _$HashtagFromJson(json);

  Map<String, dynamic> toJson() => _$HashtagToJson(this);
}
