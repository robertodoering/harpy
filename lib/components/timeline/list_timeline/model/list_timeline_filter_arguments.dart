import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_timeline_filter_arguments.freezed.dart';

@freezed
class TimelineFilterArguments with _$TimelineFilterArguments {
  const factory TimelineFilterArguments({
    required String listId,
    required String listName,
  }) = _TimelineFilterArguments;
}
