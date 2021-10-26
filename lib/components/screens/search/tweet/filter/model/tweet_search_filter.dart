import 'package:equatable/equatable.dart';

/// A filter for the twitter standard tweet search api as defined here:
/// https://developer.twitter.com/en/docs/twitter-api/v1/tweets/search/guides/standard-operators.
class TweetSearchFilter extends Equatable {
  const TweetSearchFilter({
    this.tweetAuthor = '',
    this.replyingTo = '',
    this.resultType = 0,
    this.includesPhrases = const [],
    this.includesHashtags = const [],
    this.includesMentions = const [],
    this.includesUrls = const [],
    this.includesRetweets = false,
    this.includesImages = false,
    this.includesVideo = false,
    this.excludesPhrases = const [],
    this.excludesHashtags = const [],
    this.excludesMentions = const [],
    this.excludesRetweets = false,
    this.excludesImages = false,
    this.excludesVideo = false,
  });

  final String tweetAuthor;
  final String replyingTo;

  final int resultType;

  final List<String> includesPhrases;
  final List<String> includesHashtags;
  final List<String> includesMentions;
  final List<String> includesUrls;
  final bool includesRetweets;
  final bool includesImages;
  final bool includesVideo;

  final List<String> excludesPhrases;
  final List<String> excludesHashtags;
  final List<String> excludesMentions;
  final bool excludesRetweets;
  final bool excludesImages;
  final bool excludesVideo;

  static const TweetSearchFilter empty = TweetSearchFilter();

  @override
  List<Object> get props => <Object>[
        tweetAuthor,
        replyingTo,
        resultType,
        includesPhrases,
        includesHashtags,
        includesMentions,
        includesUrls,
        includesRetweets,
        includesImages,
        includesVideo,
        excludesPhrases,
        excludesHashtags,
        excludesMentions,
        excludesRetweets,
        excludesImages,
        excludesVideo,
      ];

  TweetSearchFilter copyWith({
    String? tweetAuthor,
    String? replyingTo,
    int? resultType,
    List<String>? includesPhrases,
    List<String>? includesHashtags,
    List<String>? includesMentions,
    List<String>? includesUrls,
    bool? includesRetweets,
    bool? includesImages,
    bool? includesVideo,
    List<String>? excludesPhrases,
    List<String>? excludesHashtags,
    List<String>? excludesMentions,
    bool? excludesRetweets,
    bool? excludesImages,
    bool? excludesVideo,
  }) {
    return TweetSearchFilter(
      tweetAuthor: tweetAuthor ?? this.tweetAuthor,
      replyingTo: replyingTo ?? this.replyingTo,
      resultType: resultType ?? this.resultType,
      includesPhrases: includesPhrases ?? this.includesPhrases,
      includesHashtags: includesHashtags ?? this.includesHashtags,
      includesMentions: includesMentions ?? this.includesMentions,
      includesUrls: includesUrls ?? this.includesUrls,
      includesRetweets: includesRetweets ?? this.includesRetweets,
      includesImages: includesImages ?? this.includesImages,
      includesVideo: includesVideo ?? this.includesVideo,
      excludesPhrases: excludesPhrases ?? this.excludesPhrases,
      excludesHashtags: excludesHashtags ?? this.excludesHashtags,
      excludesMentions: excludesMentions ?? this.excludesMentions,
      excludesRetweets: excludesRetweets ?? this.excludesRetweets,
      excludesImages: excludesImages ?? this.excludesImages,
      excludesVideo: excludesVideo ?? this.excludesVideo,
    );
  }

  String buildQuery() {
    final filters = <String>[];

    if (tweetAuthor.isNotEmpty) {
      filters.add('from:$tweetAuthor');
    }

    if (replyingTo.isNotEmpty) {
      filters.add('to:$replyingTo');
    }

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

    return filters.join(' ');
  }
}
