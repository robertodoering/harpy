import 'package:json_annotation/json_annotation.dart';

part 'poll_option.g.dart';

@JsonSerializable()
class PollOption {
  PollOption(this.position, this.text);

  factory PollOption.fromJson(Map<String, dynamic> json) =>
      _$PollOptionFromJson(json);

  @JsonKey(name: "position")
  int position;
  @JsonKey(name: "text")
  String text;

  Map<String, dynamic> toJson() => _$PollOptionToJson(this);
}
