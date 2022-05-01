import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'timeline_filter.freezed.dart';
part 'timeline_filter.g.dart';

/// Describes the attributes and behavior of a timeline filter.
@freezed
class TimelineFilter with _$TimelineFilter {
  const factory TimelineFilter({
    /// A unique id for the timeline filter, generated randomly on creation.
    required String uuid,

    /// A custom user specified name for the timeline filter.
    required String name,
    required TimelineFilterIncludes includes,
    required TimelineFilterExcludes excludes,
  }) = _TimelineFilter;

  factory TimelineFilter.fromJson(Map<String, dynamic> json) =>
      _$TimelineFilterFromJson(json);

  /// Creates a new empty [TimelineFilter].
  ///
  /// Empty timeline filters are not be equal since they will have unique
  /// [uuid]s.
  factory TimelineFilter.empty() => TimelineFilter(
        uuid: const Uuid().v4(),
        name: 'New filter',
        includes: const TimelineFilterIncludes(
          image: false,
          gif: false,
          video: false,
          phrases: [],
          hashtags: [],
          mentions: [],
        ),
        excludes: const TimelineFilterExcludes(
          replies: false,
          retweets: false,
          phrases: [],
          hashtags: [],
          mentions: [],
        ),
      );
}

@freezed
class TimelineFilterIncludes with _$TimelineFilterIncludes {
  const factory TimelineFilterIncludes({
    required bool image,
    required bool gif,
    required bool video,
    required List<String> phrases,
    required List<String> hashtags,
    required List<String> mentions,
  }) = _TimelineFilterIncludes;

  factory TimelineFilterIncludes.fromJson(Map<String, dynamic> json) =>
      _$TimelineFilterIncludesFromJson(json);
}

@freezed
class TimelineFilterExcludes with _$TimelineFilterExcludes {
  const factory TimelineFilterExcludes({
    required bool replies,
    required bool retweets,
    required List<String> phrases,
    required List<String> hashtags,
    required List<String> mentions,
  }) = _TimelineFilterExcludes;

  factory TimelineFilterExcludes.fromJson(Map<String, dynamic> json) =>
      _$TimelineFilterExcludesFromJson(json);
}

/// Matches a timeline and its timeline filter. Some timelines can have unique
/// filters based on a criteria (e.g. a user timeline can have a unique filters
/// based on the user id).
@freezed
class ActiveTimelineFilter with _$ActiveTimelineFilter {
  const factory ActiveTimelineFilter({
    /// Unique id of the [TimelineFilter].
    required String uuid,
    required TimelineFilterType type,

    /// Additional data for [TimelineFilterType.user] and
    /// [TimelineFilterType.list].
    ///
    /// `null` when the type is [TimelineFilterType.home] or if the filter
    /// should be used as a generic filter for the type (i.e. all users have
    /// this generic filter unless the given user also has a unique filter which
    /// takes precedence).
    TimelineFilterData? data,
  }) = _ActiveTimelineFilter;

  factory ActiveTimelineFilter.fromJson(Map<String, dynamic> json) =>
      _$ActiveTimelineFilterFromJson(json);
}

/// Data for a timeline filter used to identify unique filters of a timeline.
@freezed
class TimelineFilterData with _$TimelineFilterData {
  const factory TimelineFilterData.user({
    /// The handle (not prefixed with an `@`) of the user.
    ///
    /// Since the handle can be modified it should not be used for matching a
    /// user but can be used to display where a filter is used.
    required String handle,

    /// The id of the user.
    required String id,
  }) = TimelineFilterDataUser;

  const factory TimelineFilterData.list({
    /// The name of the list (e.g. "Flutter").
    required String name,

    /// The id of the list.
    required String id,
  }) = TimelineFilterDataList;

  factory TimelineFilterData.fromJson(Map<String, dynamic> json) =>
      _$TimelineFilterDataFromJson(json);
}

enum TimelineFilterType {
  home,
  user,
  list,
}
