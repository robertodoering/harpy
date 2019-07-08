import 'package:json_annotation/json_annotation.dart';

part 'hashtag.g.dart';

@JsonSerializable()
class Hashtag {
  Hashtag();

  factory Hashtag.fromJson(Map<String, dynamic> json) =>
      _$HashtagFromJson(json);

  String text;
  List<int> indices;

  Map<String, dynamic> toJson() => _$HashtagToJson(this);
}
