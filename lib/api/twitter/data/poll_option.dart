import 'package:json_annotation/json_annotation.dart';

part 'poll_option.g.dart';

@JsonSerializable()
class PollOption {
  @JsonKey(name: "position")
  int position;
  @JsonKey(name: "text")
  String text;

  PollOption(this.position, this.text);

  factory PollOption.fromJson(Map<String, dynamic> json) =>
      _$PollOptionFromJson(json);

  Map<String, dynamic> toJson() => _$PollOptionToJson(this);
}
