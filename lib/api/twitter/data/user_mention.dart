import 'package:json_annotation/json_annotation.dart';

part 'user_mention.g.dart';

@JsonSerializable()
class UserMention {
  @JsonKey(name: "screen_name")
  String screenName;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "id_str")
  String idStr;
  @JsonKey(name: "indices")
  List<int> indices;

  UserMention(this.screenName, this.name, this.id, this.idStr, this.indices);

  factory UserMention.fromJson(Map<String, dynamic> json) =>
      _$UserMentionFromJson(json);

  Map<String, dynamic> toJson() => _$UserMentionToJson(this);

  @override
  String toString() {
    return 'UserMention{screenName: $screenName, name: $name, id: $id, idStr: $idStr, indices: $indices}';
  }
}
