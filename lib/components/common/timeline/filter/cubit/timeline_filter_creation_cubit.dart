import 'package:bloc/bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/utils/list_utils.dart';

class TimelineFilterCreationCubit extends Cubit<TimelineFilter>
    with HarpyLogger {
  TimelineFilterCreationCubit({
    required TimelineFilter timelineFilter,
  })  : _initialTimelineFilter = timelineFilter,
        super(timelineFilter);

  final TimelineFilter _initialTimelineFilter;

  bool get modified => state != _initialTimelineFilter;

  bool get valid => state.name.isNotEmpty;

  void updateName(String value) => emit(state.copyWith(name: value));

  // --------
  // includes
  // --------

  void updateIncludeImages(bool value) => emit(
        state.copyWith.includes(image: value),
      );

  void updateIncludeGif(bool value) => emit(
        state.copyWith.includes(gif: value),
      );

  void updateIncludeVideo(bool value) => emit(
        state.copyWith.includes(video: value),
      );

  void addIncludingPhrase(String value) => emit(
        state.copyWith.includes(
          phrases: appendToList(state.includes.phrases, value),
        ),
      );

  void removeIncludingPhrase(int index) => emit(
        state.copyWith.includes(
          phrases: removeFromList(state.includes.phrases, index),
        ),
      );

  void addIncludingHashtags(String value) => emit(
        state.copyWith.includes(
          hashtags: appendToList(state.includes.hashtags, value),
        ),
      );

  void removeIncludingHashtags(int index) => emit(
        state.copyWith.includes(
          hashtags: removeFromList(state.includes.hashtags, index),
        ),
      );

  void addIncludingMentions(String value) => emit(
        state.copyWith.includes(
          mentions: appendToList(state.includes.mentions, value),
        ),
      );

  void removeIncludingMentions(int index) => emit(
        state.copyWith.includes(
          mentions: removeFromList(state.includes.mentions, index),
        ),
      );

  // --------
  // excludes
  // --------

  void updateExcludeReplies(bool value) => emit(
        state.copyWith.excludes(replies: value),
      );

  void updateExcludeRetweets(bool value) => emit(
        state.copyWith.excludes(retweets: value),
      );

  void addExcludingPhrase(String value) => emit(
        state.copyWith.excludes(
          phrases: appendToList(state.excludes.phrases, value),
        ),
      );

  void removeExcludingPhrase(int index) => emit(
        state.copyWith.excludes(
          phrases: removeFromList(state.excludes.phrases, index),
        ),
      );

  void addExcludingHashtags(String value) => emit(
        state.copyWith.excludes(
          hashtags: appendToList(state.excludes.hashtags, value),
        ),
      );

  void removeExcludingHashtags(int index) => emit(
        state.copyWith.excludes(
          hashtags: removeFromList(state.excludes.hashtags, index),
        ),
      );

  void addExcludingMentions(String value) => emit(
        state.copyWith.excludes(
          mentions: appendToList(state.excludes.mentions, value),
        ),
      );

  void removeExcludingMentions(int index) => emit(
        state.copyWith.excludes(
          mentions: removeFromList(state.excludes.mentions, index),
        ),
      );
}
