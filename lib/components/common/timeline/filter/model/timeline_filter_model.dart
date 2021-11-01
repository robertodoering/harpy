import 'package:flutter/foundation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';

class TimelineFilterModel extends ValueNotifier<TimelineFilter> {
  TimelineFilterModel.home() : super(TimelineFilter.empty) {
    value = TimelineFilter.fromJsonString(
      app<TimelineFilterPreferences>().homeTimelineFilter,
    );
  }

  TimelineFilterModel.user() : super(TimelineFilter.empty) {
    value = TimelineFilter.fromJsonString(
      app<TimelineFilterPreferences>().userTimelineFilter,
    );
  }

  bool get hasFilter => value != TimelineFilter.empty;

  bool get toggledAllIncludes =>
      value.includesImages && value.includesGif && value.includesVideo;

  void clear() {
    value = TimelineFilter.empty;
  }

  void toggleIncludes() {
    if (toggledAllIncludes) {
      value = value.copyWith(
        includesImages: false,
        includesGif: false,
        includesVideo: false,
      );
    } else {
      value = value.copyWith(
        includesImages: true,
        includesGif: true,
        includesVideo: true,
      );
    }
  }

  void setIncludesImages(bool includesImages) {
    value = value.copyWith(
      includesImages: includesImages,
    );
  }

  void setIncludesGif(bool includesGif) {
    value = value.copyWith(
      includesGif: includesGif,
    );
  }

  void setIncludesVideo(bool includesVideo) {
    value = value.copyWith(
      includesVideo: includesVideo,
    );
  }

  void addExcludingPhrase(String phrase) {
    value = value.copyWith(
      excludesPhrases: appendToList(
        value.excludesPhrases,
        phrase,
      ),
    );
  }

  void removeExcludingPhrase(int index) {
    value = value.copyWith(
      excludesPhrases: removeFromList(value.excludesPhrases, index),
    );
  }

  void addExcludingHashtag(String hashtag) {
    value = value.copyWith(
      excludesHashtags: appendToList(
        value.excludesHashtags,
        prependIfMissing(
          hashtag.replaceAll(nonHashtagCharactersRegex, ''),
          '#',
          ['#', '＃'],
        ),
      ),
    );
  }

  void removeExcludingHashtag(int index) {
    value = value.copyWith(
      excludesHashtags: removeFromList(value.excludesHashtags, index),
    );
  }

  void setExcludesReplies(bool excludesReplies) {
    value = value.copyWith(excludesReplies: excludesReplies);
  }

  void setExcludesRetweets(bool excludesRetweets) {
    value = value.copyWith(excludesRetweets: excludesRetweets);
  }
}
