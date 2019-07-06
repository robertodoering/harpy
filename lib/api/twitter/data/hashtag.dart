import 'package:json_annotation/json_annotation.dart';

part 'hashtag.g.dart';

@JsonSerializable()
class Hashtag {
  Hashtag(this.text, this.indices);

  factory Hashtag.fromJson(Map<String, dynamic> json) =>
      _$HashtagFromJson(json);

  @JsonKey(name: "text")
  String text;
  @JsonKey(name: "indices")
  List<int> indices;

  Map<String, dynamic> toJson() => _$HashtagToJson(this);

  @override
  String toString() {
    return 'Hashtag{text: $text, indices: $indices}';
  }
}
