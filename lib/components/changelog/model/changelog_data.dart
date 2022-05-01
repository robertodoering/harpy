import 'package:built_collection/built_collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'changelog_data.freezed.dart';

@freezed
class ChangelogData with _$ChangelogData {
  const factory ChangelogData({
    required String? title,
    required DateTime? date,
    required BuiltList<String> summary,
    required BuiltList<ChangelogEntry> entries,
  }) = _ChangelogData;
}

@freezed
class ChangelogEntry with _$ChangelogEntry {
  const factory ChangelogEntry({
    required String line,
    required ChangelogEntryType type,
    required BuiltList<ChangelogEntry> subEntries,
  }) = _ChangelogEntry;
}

enum ChangelogEntryType {
  added,
  improved,
  changed,
  updated,
  fixed,
  removed,
  other,
}
