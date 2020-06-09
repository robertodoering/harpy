import 'package:json_annotation/json_annotation.dart';

part 'user_mention.g.dart';

@JsonSerializable()
class UserMention {
  UserMention();

  factory UserMention.fromJson(Map<String, dynamic> json) =>
      _$UserMentionFromJson(json);

  @JsonKey(name: "screen_name")
  String screenName;
  String name;
  int id;
  @JsonKey(name: "id_str")
  String idStr;
  List<int> indices;

  Map<String, dynamic> toJson() => _$UserMentionToJson(this);
}
