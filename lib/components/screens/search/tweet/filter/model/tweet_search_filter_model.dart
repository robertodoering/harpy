import 'package:flutter/foundation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/misc/misc.dart';

/// A [ValueNotifier] for a [TweetSearchFilter].
///
/// Used in the [TweetSearchFilterDrawer] to filter the results for the tweet
/// search.
class TweetSearchFilterModel extends ValueNotifier<TweetSearchFilter> {
  TweetSearchFilterModel(TweetSearchFilter value) : super(value);

  bool get hasFilter => value != TweetSearchFilter.empty;

  bool get hasSearchQuery => value.buildQuery().isNotEmpty;

  bool get enableIncludesRetweets => value.excludesRetweets == false;

  bool get enableIncludesImages => value.excludesImages == false;

  bool get enableIncludesVideos => value.excludesVideo == false;

  bool get enableExcludesRetweets => value.includesRetweets == false;

  bool get enableExcludesImages => value.includesImages == false;

  bool get enableExcludesVideos => value.includesVideo == false;

  void clear() {
    value = TweetSearchFilter.empty;
  }

  void setTweetAuthor(String tweetAuthor) {
    if (tweetAuthor.isEmpty) {
      value = value.copyWith(tweetAuthor: '');
    } else {
      value = value.copyWith(
        tweetAuthor: removePrependedSymbol(tweetAuthor, ['@']),
      );
    }
  }

  void setReplyingTo(String replyingTo) {
    if (replyingTo.isEmpty) {
      value = value.copyWith(replyingTo: '');
    } else {
      value = value.copyWith(
        replyingTo: removePrependedSymbol(replyingTo, ['@']),
      );
    }
  }

  void setResultType(int? resultType) {
    value = value.copyWith(resultType: resultType!.clamp(0, 2));
  }

  void addIncludingPhrase(String phrase) {
    value = value.copyWith(
      includesPhrases: appendToList(value.includesPhrases, phrase),
    );
  }

  void removeIncludingPhrase(int index) {
    value = value.copyWith(
      includesPhrases: removeFromList(value.includesPhrases, index),
    );
  }

  void addIncludingHashtag(String hashtag) {
    value = value.copyWith(
      includesHashtags: appendToList(
        value.includesHashtags,
        prependIfMissing(hashtag, '#', ['#', '＃']),
      ),
    );
  }

  void removeIncludingHashtag(int index) {
    value = value.copyWith(
      includesHashtags: removeFromList(value.includesHashtags, index),
    );
  }

  void addIncludingMention(String mention) {
    value = value.copyWith(
      includesMentions: appendToList(
        value.includesMentions,
        prependIfMissing(mention, '@', ['@']),
      ),
    );
  }

  void removeIncludingMention(int index) {
    value = value.copyWith(
      includesMentions: removeFromList(value.includesMentions, index),
    );
  }

  void addIncludingUrl(String url) {
    value = value.copyWith(
      includesUrls: appendToList(value.includesUrls, url),
    );
  }

  void removeIncludingUrls(int index) {
    value = value.copyWith(
      includesUrls: removeFromList(value.includesUrls, index),
    );
  }

  void setIncludesImages(bool includesImages) {
    value = value.copyWith(includesImages: includesImages);
  }

  void setIncludesRetweets(bool includesRetweets) {
    value = value.copyWith(includesRetweets: includesRetweets);
  }

  void setIncludesVideo(bool includesVideo) {
    value = value.copyWith(includesVideo: includesVideo);
  }

  void addExcludingPhrase(String phrase) {
    value = value.copyWith(
      excludesPhrases: appendToList(value.excludesPhrases, phrase),
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
        prependIfMissing(hashtag, '#', ['#', '＃']),
      ),
    );
  }

  void removeExcludingHashtag(int index) {
    value = value.copyWith(
      excludesHashtags: removeFromList(value.excludesHashtags, index),
    );
  }

  void addExcludingMention(String mention) {
    value = value.copyWith(
      excludesMentions: appendToList(
        value.excludesMentions,
        prependIfMissing(mention, '@', ['@']),
      ),
    );
  }

  void removeExcludingMention(int index) {
    value = value.copyWith(
      excludesMentions: removeFromList(value.excludesMentions, index),
    );
  }

  void setExcludesRetweets(bool excludesRetweets) {
    value = value.copyWith(excludesRetweets: excludesRetweets);
  }

  void setExcludesImages(bool excludesImages) {
    value = value.copyWith(excludesImages: excludesImages);
  }

  void setExcludesVideo(bool excludesVideo) {
    value = value.copyWith(excludesVideo: excludesVideo);
  }
}
