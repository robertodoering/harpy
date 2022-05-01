import 'package:freezed_annotation/freezed_annotation.dart';

part 'tweet_search_filter_data.freezed.dart';

enum TweetSearchResultType {
  mixed,
  recent,
  popular,
}

@freezed
class TweetSearchFilterData with _$TweetSearchFilterData {
  factory TweetSearchFilterData({
    @Default('') String tweetAuthor,
    @Default('') String replyingTo,
    @Default(TweetSearchResultType.mixed) TweetSearchResultType resultType,
    @Default(<String>[]) List<String> includesPhrases,
    @Default(<String>[]) List<String> includesHashtags,
    @Default(<String>[]) List<String> includesMentions,
    @Default(<String>[]) List<String> includesUrls,
    @Default(false) bool includesRetweets,
    @Default(false) bool includesImages,
    @Default(false) bool includesVideo,
    @Default(<String>[]) List<String> excludesPhrases,
    @Default(<String>[]) List<String> excludesHashtags,
    @Default(<String>[]) List<String> excludesMentions,
    @Default(false) bool excludesRetweets,
    @Default(false) bool excludesImages,
    @Default(false) bool excludesVideo,
  }) = _TweetSearchFilterData;

  TweetSearchFilterData._();

  late final isValid = tweetAuthor.isNotEmpty ||
      replyingTo.isNotEmpty ||
      includesPhrases.isNotEmpty ||
      includesHashtags.isNotEmpty ||
      includesMentions.isNotEmpty ||
      includesUrls.isNotEmpty;

  bool isEmpty() => this == TweetSearchFilterData();

  String buildQuery() {
    final filters = <String>[];

    if (tweetAuthor.isNotEmpty) filters.add('from:$tweetAuthor');
    if (replyingTo.isNotEmpty) filters.add('to:$replyingTo');

    // phrases & keywords
    for (final phrase in includesPhrases) {
      if (phrase.contains(' ')) {
        // multi word phrase
        filters.add('"$phrase"');
      } else {
        // single key word
        filters.add(phrase);
      }
    }

    for (final phrase in excludesPhrases) {
      if (phrase.contains(' ')) {
        // multi word phrase
        filters.add('-"$phrase"');
      } else {
        // single key word
        filters.add('-$phrase');
      }
    }

    // hashtags & mentions
    includesHashtags.forEach(filters.add);
    excludesHashtags.forEach(filters.add);
    includesMentions.forEach(filters.add);
    excludesMentions.forEach(filters.add);

    // urls
    for (final url in includesUrls) {
      filters.add('url:$url');
    }

    // retweets
    if (includesRetweets) {
      filters.add('filter:retweets');
    } else if (excludesRetweets) {
      filters.add('-filter:retweets');
    }

    // media
    if (includesImages && includesVideo) {
      filters.add('filter:media');
    } else if (excludesImages && excludesVideo) {
      filters.add('-filter:media');
    } else {
      if (includesImages) {
        filters.add('filter:images');
      } else if (excludesImages) {
        filters.add('-filter:images');
      }

      if (includesVideo) {
        filters.add('filter:native_video');
      } else if (excludesVideo) {
        filters.add('-filter:native_video');
      }
    }

    return filters.join(' ').trim();
  }
}
