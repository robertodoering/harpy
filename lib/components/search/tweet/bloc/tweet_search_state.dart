part of 'tweet_search_bloc.dart';

abstract class TweetSearchState extends Equatable {
  const TweetSearchState();
}

class TweetSearchInitial extends TweetSearchState {
  const TweetSearchInitial();

  @override
  List<Object> get props => <Object>[];
}

class TweetSearchLoading extends TweetSearchState {
  const TweetSearchLoading({
    @required this.searchQuery,
  });

  /// The query that was used in the search request.
  final String searchQuery;

  @override
  List<Object> get props => <Object>[];
}

class TweetSearchResult extends TweetSearchState {
  const TweetSearchResult({
    @required this.tweets,
    @required this.searchQuery,
    this.filter,
  });

  final List<TweetData> tweets;

  /// The query that was used in the search request.
  ///
  /// Either built from the [filter] or manually entered by the user.
  final String searchQuery;

  /// The filter that built the [searchQuery] if a filter was used.
  ///
  /// `null` if the user entered the query manually.
  final TweetSearchFilter filter;

  @override
  List<Object> get props => <Object>[
        tweets,
        searchQuery,
        filter,
      ];
}

class TweetSearchFailure extends TweetSearchState {
  const TweetSearchFailure({
    @required this.searchQuery,
    this.filter,
  });

  /// The query that was used in the search request.
  ///
  /// Used to retry the request using a [SearchTweets] event.
  final String searchQuery;

  /// The filter that built the [searchQuery] if a filter was used.
  final TweetSearchFilter filter;

  @override
  List<Object> get props => <Object>[
        searchQuery,
        filter,
      ];
}
