import 'package:harpy/api/twitter/data/poll_option.dart';
import 'package:json_annotation/json_annotation.dart';

part 'poll.g.dart';

@JsonSerializable()
class Poll {
  Poll();

  factory Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);

  @JsonKey(name: "end_datetime")
  DateTime endDatetime;
  @JsonKey(name: "duration_minutes")
  int durationMinutes;
  List<PollOption> options;

  Map<String, dynamic> toJson() => _$PollToJson(this);
}
