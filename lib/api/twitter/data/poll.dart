import 'package:harpy/api/twitter/data/poll_option.dart';
import 'package:harpy/core/utils/date_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'poll.g.dart';

@JsonSerializable()
class Poll {
  @JsonKey(name: "end_datetime")
  DateTime endDatetime;
  @JsonKey(name: "duration_minutes")
  int duration;
  @JsonKey(name: "options")
  List<PollOption> pollOptions;

  Poll(this.endDatetime, this.duration, this.pollOptions);

  factory Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);

  Map<String, dynamic> toJson() => _$PollToJson(this);

  @override
  String toString() {
    return 'Poll{endDatetime: $endDatetime, duration: $duration, pollOptions: $pollOptions}';
  }
}
