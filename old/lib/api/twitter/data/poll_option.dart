import 'package:json_annotation/json_annotation.dart';

part 'poll_option.g.dart';

@JsonSerializable()
class PollOption {
  PollOption();

  factory PollOption.fromJson(Map<String, dynamic> json) =>
      _$PollOptionFromJson(json);

  int position;
  String text;

  Map<String, dynamic> toJson() => _$PollOptionToJson(this);
}
