import 'package:flutter/foundation.dart';
import 'package:harpy/components/search/tweet/filter/model/tweet_search_filter.dart';
import 'package:harpy/misc/utils/string_utils.dart';

/// A [ValueNotifier] for a [TweetSearchFilter].
///
/// Used in the [TweetSearchFilterDrawer] to filter the results for the tweet
/// search.
class TweetSearchFilterModel extends ValueNotifier<TweetSearchFilter> {
  TweetSearchFilterModel(TweetSearchFilter value) : super(value);

  bool get enableIncludesRetweets => value.excludesRetweets == false;

  bool get enableIncludesImages => value.excludesImages == false;

  bool get enableIncludesVideos => value.excludesVideo == false;

  bool get enableExcludesRetweets => value.includesRetweets == false;

  bool get enableExcludesImages => value.includesImages == false;

  bool get enableExcludesVideos => value.includesVideo == false;

  void setTweetAuthor(String tweetAuthor) {
    if (tweetAuthor == null || tweetAuthor.isEmpty) {
      value = value.copyWith(tweetAuthor: null);
    } else {
      value = value.copyWith(
        tweetAuthor: removePrependedSymbol(tweetAuthor, <String>['@']),
      );
    }
  }

  void setReplyingTo(String replyingTo) {
    if (replyingTo == null || replyingTo.isEmpty) {
      value = value.copyWith(tweetAuthor: null);
    } else {
      value = value.copyWith(
        tweetAuthor: removePrependedSymbol(replyingTo, <String>['@']),
      );
    }
  }

  void addIncludingPhrase(String phrase) {
    _appendToList(
      value: phrase,
      list: value.includesPhrases,
      onListUpdated: (List<String> list) => value = value.copyWith(
        includesPhrases: list,
      ),
    );
  }

  void removeIncludingPhrase(int index) {
    _removeFromList(
      index: index,
      list: value.includesPhrases,
      onListUpdated: (List<String> list) => value = value.copyWith(
        includesPhrases: list,
      ),
    );
  }

  void addIncludingHashtag(String hashtag) {
    _appendToList(
      value: prependIfMissing(hashtag, '#', <String>['#', '＃']),
      list: value.includesHashtags,
      onListUpdated: (List<String> list) => value = value.copyWith(
        includesHashtags: list,
      ),
    );
  }

  void removeIncludingHashtag(int index) {
    _removeFromList(
      index: index,
      list: value.includesHashtags,
      onListUpdated: (List<String> list) => value = value.copyWith(
        includesHashtags: list,
      ),
    );
  }

  void addIncludingMention(String mention) {
    _appendToList(
      value: prependIfMissing(mention, '@', <String>['@']),
      list: value.includesMentions,
      onListUpdated: (List<String> list) => value = value.copyWith(
        includesMentions: list,
      ),
    );
  }

  void removeIncludingMention(int index) {
    _removeFromList(
      index: index,
      list: value.includesMentions,
      onListUpdated: (List<String> list) => value = value.copyWith(
        includesMentions: list,
      ),
    );
  }

  void addIncludingUrl(String url) {
    _appendToList(
      value: url,
      list: value.includesUrls,
      onListUpdated: (List<String> list) => value = value.copyWith(
        includesUrls: list,
      ),
    );
  }

  void removeIncludingUrls(int index) {
    _removeFromList(
      index: index,
      list: value.includesUrls,
      onListUpdated: (List<String> list) => value = value.copyWith(
        includesUrls: list,
      ),
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
    _appendToList(
      value: phrase,
      list: value.excludesPhrases,
      onListUpdated: (List<String> list) => value = value.copyWith(
        excludesPhrases: list,
      ),
    );
  }

  void removeExcludingPhrase(int index) {
    _removeFromList(
      index: index,
      list: value.excludesPhrases,
      onListUpdated: (List<String> list) => value = value.copyWith(
        excludesPhrases: list,
      ),
    );
  }

  void addExcludingHashtag(String hashtag) {
    _appendToList(
      value: prependIfMissing(hashtag, '#', <String>['#', '＃']),
      list: value.excludesHashtags,
      onListUpdated: (List<String> list) => value = value.copyWith(
        excludesHashtags: list,
      ),
    );
  }

  void removeExcludingHashtag(int index) {
    _removeFromList(
      index: index,
      list: value.excludesHashtags,
      onListUpdated: (List<String> list) => value = value.copyWith(
        excludesHashtags: list,
      ),
    );
  }

  void addExcludingMention(String mention) {
    _appendToList(
      value: prependIfMissing(mention, '@', <String>['@']),
      list: value.excludesMentions,
      onListUpdated: (List<String> list) => value = value.copyWith(
        excludesMentions: list,
      ),
    );
  }

  void removeExcludingMention(int index) {
    _removeFromList(
      index: index,
      list: value.excludesMentions,
      onListUpdated: (List<String> list) => value = value.copyWith(
        excludesMentions: list,
      ),
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

  void _appendToList({
    @required String value,
    @required List<String> list,
    @required ValueChanged<List<String>> onListUpdated,
  }) {
    if (value != null && value.isNotEmpty) {
      final List<String> updatedList = List<String>.of(list ?? <String>[]);
      updatedList.add(value);
      onListUpdated(updatedList);
    }
  }

  void _removeFromList({
    @required int index,
    @required List<String> list,
    @required ValueChanged<List<String>> onListUpdated,
  }) {
    final List<String> updatedList = List<String>.of(list);

    if (index >= 0 && index < updatedList.length) {
      updatedList.removeAt(index);
      onListUpdated(updatedList);
    }
  }
}
