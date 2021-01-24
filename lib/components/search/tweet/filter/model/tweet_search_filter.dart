import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class TweetSearchFilter extends Equatable {
  const TweetSearchFilter({
    this.tweetAuthor = '',
    this.replyingTo = '',
    this.includesPhrases = const <String>[],
    this.includesHashtags = const <String>[],
    this.includesMentions = const <String>[],
    this.includesUrls = const <String>[],
    this.includesImages = false,
    this.includesVideo = false,
    this.excludesPhrases = const <String>[],
    this.excludesHashtags = const <String>[],
    this.excludesMentions = const <String>[],
    this.excludesImages = false,
    this.excludesVideo = false,
  });

  final String tweetAuthor;
  final String replyingTo;

  final List<String> includesPhrases;
  final List<String> includesHashtags;
  final List<String> includesMentions;
  final List<String> includesUrls;
  final bool includesImages;
  final bool includesVideo;

  final List<String> excludesPhrases;
  final List<String> excludesHashtags;
  final List<String> excludesMentions;
  final bool excludesImages;
  final bool excludesVideo;

  @override
  List<Object> get props => <Object>[
        tweetAuthor,
        includesPhrases,
        includesHashtags,
        includesMentions,
        includesUrls,
        includesImages,
        includesVideo,
        excludesPhrases,
        excludesHashtags,
        excludesMentions,
        excludesImages,
        excludesVideo,
      ];

  TweetSearchFilter copyWith({
    String tweetAuthor,
    String replyingTo,
    List<String> includesPhrases,
    List<String> includesHashtags,
    List<String> includesMentions,
    List<String> includesUrls,
    bool includesImages,
    bool includesVideo,
    List<String> excludesPhrases,
    List<String> excludesHashtags,
    List<String> excludesMentions,
    bool excludesImages,
    bool excludesVideo,
  }) {
    return TweetSearchFilter(
      tweetAuthor: tweetAuthor ?? this.tweetAuthor,
      replyingTo: replyingTo ?? this.replyingTo,
      includesPhrases: includesPhrases ?? this.includesPhrases,
      includesHashtags: includesHashtags ?? this.includesHashtags,
      includesMentions: includesMentions ?? this.includesMentions,
      includesUrls: includesUrls ?? this.includesUrls,
      includesImages: includesImages ?? this.includesImages,
      includesVideo: includesVideo ?? this.includesVideo,
      excludesPhrases: excludesPhrases ?? this.excludesPhrases,
      excludesHashtags: excludesHashtags ?? this.excludesHashtags,
      excludesMentions: excludesMentions ?? this.excludesMentions,
      excludesImages: excludesImages ?? this.excludesImages,
      excludesVideo: excludesVideo ?? this.excludesVideo,
    );
  }

  String buildQuery() {
    // todo: build the query from the filters
    throw UnimplementedError();
  }
}
