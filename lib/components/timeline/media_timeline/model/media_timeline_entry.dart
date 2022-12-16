import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';

part 'media_timeline_entry.freezed.dart';

/// An entry for a media timeline that maps a [LegacyTweetData] to its
/// [MediaData].
///
/// A single tweet might have multiple media data (i.e. more than one image).
@freezed
class MediaTimelineEntry with _$MediaTimelineEntry {
  const factory MediaTimelineEntry({
    required LegacyTweetData tweet,
    required MediaData media,
  }) = _MediaTimelineEntry;
}
