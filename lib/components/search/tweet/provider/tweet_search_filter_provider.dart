import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final tweetSearchFilterProvider = StateNotifierProvider.autoDispose.family<
    TweetSearchFilterNotifier, TweetSearchFilterData, TweetSearchFilterData?>(
  (ref, initialFilter) => TweetSearchFilterNotifier(
    initialFilter: initialFilter,
  ),
  name: 'TweetSearchFilterProvider',
);

class TweetSearchFilterNotifier extends StateNotifier<TweetSearchFilterData> {
  TweetSearchFilterNotifier({
    required TweetSearchFilterData? initialFilter,
  }) : super(initialFilter ?? TweetSearchFilterData());

  void clear() {
    state = TweetSearchFilterData();
  }

  void setTweetAuthor(String tweetAuthor) {
    state = state.copyWith(
      tweetAuthor: removePrependedSymbol(tweetAuthor, ['@']) ?? '',
    );
  }

  void setReplyingTo(String replyingTo) {
    state = state.copyWith(
      replyingTo: removePrependedSymbol(replyingTo, ['@']) ?? '',
    );
  }

  void setResultType(TweetSearchResultType resultType) {
    state = state.copyWith(resultType: resultType);
  }

  void addIncludingPhrase(String phrase) {
    state = state.copyWith(
      includesPhrases: state.includesPhrases.copySafeAdd(phrase),
    );
  }

  void removeIncludingPhrase(int index) {
    state = state.copyWith(
      includesPhrases: state.includesPhrases.copySafeRemoveAt(index),
    );
  }

  void addIncludingHashtag(String hashtag) {
    state = state.copyWith(
      includesHashtags: state.includesHashtags.copySafeAdd(
        prependIfMissing(hashtag, '#', ['#', '＃']),
      ),
    );
  }

  void removeIncludingHashtag(int index) {
    state = state.copyWith(
      includesHashtags: state.includesHashtags.copySafeRemoveAt(index),
    );
  }

  void addIncludingMention(String mention) {
    state = state.copyWith(
      includesMentions: state.includesMentions.copySafeAdd(
        prependIfMissing(mention, '@', ['@']),
      ),
    );
  }

  void removeIncludingMention(int index) {
    state = state.copyWith(
      includesMentions: state.includesMentions.copySafeRemoveAt(index),
    );
  }

  void addIncludingUrl(String url) {
    state = state.copyWith(
      includesUrls: state.includesUrls.copySafeAdd(url),
    );
  }

  void removeIncludingUrls(int index) {
    state = state.copyWith(
      includesUrls: state.includesUrls.copySafeRemoveAt(index),
    );
  }

  void setIncludesImages(bool includesImages) {
    state = state.copyWith(includesImages: includesImages);
  }

  void setIncludesRetweets(bool includesRetweets) {
    state = state.copyWith(includesRetweets: includesRetweets);
  }

  void setIncludesVideo(bool includesVideo) {
    state = state.copyWith(includesVideo: includesVideo);
  }

  void addExcludingPhrase(String phrase) {
    state = state.copyWith(
      excludesPhrases: state.excludesPhrases.copySafeAdd(phrase),
    );
  }

  void removeExcludingPhrase(int index) {
    state = state.copyWith(
      excludesPhrases: state.excludesPhrases.copySafeRemoveAt(index),
    );
  }

  void addExcludingHashtag(String hashtag) {
    state = state.copyWith(
      excludesHashtags: state.excludesHashtags.copySafeAdd(
        prependIfMissing(hashtag, '#', ['#', '＃']),
      ),
    );
  }

  void removeExcludingHashtag(int index) {
    state = state.copyWith(
      excludesHashtags: state.excludesHashtags.copySafeRemoveAt(index),
    );
  }

  void addExcludingMention(String mention) {
    state = state.copyWith(
      excludesMentions: state.excludesMentions.copySafeAdd(
        prependIfMissing(mention, '@', ['@']),
      ),
    );
  }

  void removeExcludingMention(int index) {
    state = state.copyWith(
      excludesMentions: state.excludesMentions.copySafeRemoveAt(index),
    );
  }

  void setExcludesRetweets(bool excludesRetweets) {
    state = state.copyWith(excludesRetweets: excludesRetweets);
  }

  void setExcludesImages(bool excludesImages) {
    state = state.copyWith(excludesImages: excludesImages);
  }

  void setExcludesVideo(bool excludesVideo) {
    state = state.copyWith(excludesVideo: excludesVideo);
  }
}
