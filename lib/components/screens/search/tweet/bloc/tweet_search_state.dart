part of 'tweet_search_bloc.dart';

abstract class TweetSearchState extends Equatable {
  const TweetSearchState();

  bool get showLoading => this is TweetSearchLoading;

  bool get showNoResults =>
      this is TweetSearchResult && (this as TweetSearchResult).tweets.isEmpty;

  bool get showSearchError => this is TweetSearchFailure;

  bool get hasResults =>
      this is TweetSearchResult &&
      (this as TweetSearchResult).tweets.isNotEmpty;

  /// Returns the active search query or `null` if none exist yet.
  String? get searchQuery {
    if (this is TweetSearchResult) {
      return (this as TweetSearchResult).query;
    } else if (this is TweetSearchLoading) {
      return (this as TweetSearchLoading).query;
    } else if (this is TweetSearchFailure) {
      return (this as TweetSearchFailure).query;
    } else {
      return null;
    }
  }
}

class TweetSearchInitial extends TweetSearchState {
  const TweetSearchInitial();

  @override
  List<Object> get props => <Object>[];
}

class TweetSearchLoading extends TweetSearchState {
  const TweetSearchLoading({
    required this.query,
  });

  /// The query that was used in the search request.
  final String query;

  @override
  List<Object> get props => <Object>[];
}

class TweetSearchResult extends TweetSearchState {
  const TweetSearchResult({
    required this.tweets,
    required this.query,
    this.filter,
  });

  final List<TweetData> tweets;

  /// The query that was used in the search request.
  ///
  /// Either built from the [filter] or manually entered by the user.
  final String query;

  /// The filter that built the [query] if a filter was used.
  ///
  /// `null` if the user entered the query manually.
  final TweetSearchFilter? filter;

  @override
  List<Object?> get props => <Object?>[
        tweets,
        query,
        filter,
      ];
}

class TweetSearchFailure extends TweetSearchState {
  const TweetSearchFailure({
    required this.query,
    this.filter,
  });

  /// The query that was used in the search request.
  ///
  /// Used to retry the request using a [SearchTweets] event.
  final String query;

  /// The filter that built the [query] if a filter was used.
  final TweetSearchFilter? filter;

  @override
  List<Object?> get props => <Object?>[
        query,
        filter,
      ];
}
