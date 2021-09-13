part of 'tweet_search_bloc.dart';

abstract class TweetSearchEvent extends Equatable {
  const TweetSearchEvent();

  Stream<TweetSearchState> applyAsync({
    required TweetSearchState currentState,
    required TweetSearchBloc bloc,
  });
}

/// Searches tweets based on the [customQuery] or the [filter].
///
/// Does nothing if the query is `null` or empty and the filter is `null` or
/// builds an empty query.
///
/// Does nothing if the current state is a [TweetSearchResult] and the search
/// query and filter is the same.
///
/// Yields a [TweetSearchResult] on successful request or a
/// [TweetSearchFailure] on failure.
class SearchTweets extends TweetSearchEvent {
  const SearchTweets({
    this.customQuery,
    this.filter,
  });

  /// The query that the user entered in the search field.
  ///
  /// `null` if the [filter] was used to search tweets.
  final String? customQuery;

  /// The filter that builds the tweet search query.
  ///
  /// `null` if a [customQuery] was used to search tweets.
  final TweetSearchFilter? filter;

  static final Logger _log = Logger('SearchTweets');

  @override
  List<Object?> get props => <Object?>[
        customQuery,
        filter,
      ];

  bool _unchangedQuery(String? query, TweetSearchState currentState) {
    if (currentState is TweetSearchResult) {
      return currentState.query == query && currentState.filter == filter;
    } else {
      return false;
    }
  }

  String? _searchQuery() {
    if (customQuery != null && customQuery!.trim().isNotEmpty) {
      return customQuery;
    } else if (filter != null) {
      final filterQuery = filter!.buildQuery();

      if (filterQuery.trim().isNotEmpty) {
        return filterQuery;
      }
    }

    return null;
  }

  String? _resultType() {
    if (filter != null) {
      if (filter!.resultType == 0) {
        return 'mixed';
      } else if (filter!.resultType == 1) {
        return 'recent';
      } else if (filter!.resultType == 2) {
        return 'popular';
      }
    }

    return null;
  }

  List<TweetData> _transformTweets(List<Tweet> tweets) {
    return tweets.map((tweet) => TweetData.fromTweet(tweet)).toList();
  }

  @override
  Stream<TweetSearchState> applyAsync({
    required TweetSearchState currentState,
    required TweetSearchBloc bloc,
  }) async* {
    final query = _searchQuery();

    if (_unchangedQuery(query, currentState)) {
      _log.fine('search query does not differ from last query');
      return;
    }

    if (query != null) {
      _log.fine('searching tweets');

      yield TweetSearchLoading(query: query);

      final tweets = await bloc.searchService
          .searchTweets(
            q: query,
            count: 100,
            resultType: _resultType(),
          )
          .then((result) => _transformTweets(result.statuses!))
          .handleError(twitterApiErrorHandler);

      if (tweets != null) {
        _log.fine('found ${tweets.length} tweets for query: $query');

        yield TweetSearchResult(
          filter: filter,
          query: query,
          tweets: tweets,
        );
      } else {
        yield TweetSearchFailure(query: query, filter: filter);
      }
    }
  }
}

/// Retries the last search if it failed.
///
/// Does nothing if the current state is not a [TweetSearchFailure].
class RetryTweetSearch extends TweetSearchEvent {
  const RetryTweetSearch();

  @override
  List<Object> get props => <Object>[];

  @override
  Stream<TweetSearchState> applyAsync({
    required TweetSearchState currentState,
    required TweetSearchBloc bloc,
  }) async* {
    if (currentState is TweetSearchFailure) {
      bloc.add(
        SearchTweets(
          customQuery: currentState.query,
          filter: currentState.filter,
        ),
      );
    }
  }
}

/// Yields a [TweetSearchInitial] to reset the bloc and clear any results.
class ClearSearchResult extends TweetSearchEvent {
  const ClearSearchResult();

  @override
  List<Object> get props => <Object>[];

  @override
  Stream<TweetSearchState> applyAsync({
    required TweetSearchState currentState,
    required TweetSearchBloc bloc,
  }) async* {
    yield const TweetSearchInitial();
  }
}
