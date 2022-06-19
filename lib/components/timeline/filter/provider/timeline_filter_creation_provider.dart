import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final timelineFilterCreationProvider = StateNotifierProvider.autoDispose
    .family<TimelineFilterCreationNotifier, TimelineFilter, TimelineFilter>(
  (ref, initialTimelineFilter) => TimelineFilterCreationNotifier(
    initialTimelineFilter: initialTimelineFilter,
  ),
  name: 'TimelineFilterCreationProvider',
);

class TimelineFilterCreationNotifier extends StateNotifier<TimelineFilter> {
  TimelineFilterCreationNotifier({
    required TimelineFilter initialTimelineFilter,
  })  : _initialTimelineFilter = initialTimelineFilter,
        super(initialTimelineFilter);

  final TimelineFilter _initialTimelineFilter;

  bool get modified => mounted && state != _initialTimelineFilter;

  bool get valid => mounted && state.name.isNotEmpty;

  void updateName(String value) => state = state.copyWith(name: value);

  // --------
  // includes
  // --------

  void updateIncludeImages(bool value) =>
      state = state.copyWith.includes(image: value);

  void updateIncludeGif(bool value) =>
      state = state.copyWith.includes(gif: value);

  void updateIncludeVideo(bool value) =>
      state = state.copyWith.includes(video: value);

  void addIncludingPhrase(String value) => state = state.copyWith.includes(
        phrases: state.includes.phrases.copySafeAdd(value),
      );

  void removeIncludingPhrase(int index) => state = state.copyWith.includes(
        phrases: state.includes.phrases.copySafeRemoveAt(index),
      );

  void addIncludingHashtags(String value) => state = state.copyWith.includes(
        hashtags: state.includes.hashtags.copySafeAdd(value),
      );

  void removeIncludingHashtags(int index) => state = state.copyWith.includes(
        hashtags: state.includes.hashtags.copySafeRemoveAt(index),
      );

  void addIncludingMentions(String value) => state = state.copyWith.includes(
        mentions: state.includes.mentions.copySafeAdd(value),
      );

  void removeIncludingMentions(int index) => state = state.copyWith.includes(
        mentions: state.includes.mentions.copySafeRemoveAt(index),
      );

  // --------
  // excludes
  // --------

  void updateExcludeReplies(bool value) =>
      state = state.copyWith.excludes(replies: value);

  void updateExcludeRetweets(bool value) =>
      state = state.copyWith.excludes(retweets: value);

  void addExcludingPhrase(String value) => state = state.copyWith.excludes(
        phrases: state.excludes.phrases.copySafeAdd(value),
      );

  void removeExcludingPhrase(int index) => state = state.copyWith.excludes(
        phrases: state.excludes.phrases.copySafeRemoveAt(index),
      );

  void addExcludingHashtags(String value) => state = state.copyWith.excludes(
        hashtags: state.excludes.hashtags.copySafeAdd(value),
      );

  void removeExcludingHashtags(int index) => state = state.copyWith.excludes(
        hashtags: state.excludes.hashtags.copySafeRemoveAt(index),
      );

  void addExcludingMentions(String value) => state = state.copyWith.excludes(
        mentions: state.excludes.mentions.copySafeAdd(value),
      );

  void removeExcludingMentions(int index) => state = state.copyWith.excludes(
        mentions: state.excludes.mentions.copySafeRemoveAt(index),
      );
}
