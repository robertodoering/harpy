part of 'tweet_search_bloc.dart';

abstract class TweetSearchEvent extends Equatable {
  const TweetSearchEvent();

  Stream<TweetSearchState> applyAsync({
    TweetSearchState currentState,
    TweetSearchBloc bloc,
  });
}

/// Searches tweets based on the [query] or the [filter].
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
    this.query,
    this.filter,
  });

  final String query;
  final TweetSearchFilter filter;

  static final Logger _log = Logger('SearchTweets');

  @override
  List<Object> get props => <Object>[
        query,
        filter,
      ];

  bool _unchangedQuery(String searchQuery, TweetSearchState currentState) {
    if (currentState is TweetSearchResult) {
      return currentState.searchQuery == searchQuery &&
          currentState.filter == filter;
    } else {
      return false;
    }
  }

  String _searchQuery() {
    if (query != null && query.trim().isNotEmpty) {
      return query;
    } else if (filter != null) {
      final String filterQuery = filter.buildQuery();

      if (filterQuery != null && filterQuery.trim().isNotEmpty) {
        return filterQuery;
      }
    }

    return null;
  }

  String _resultType() {
    if (filter != null) {
      if (filter.resultType == 0) {
        return 'mixed';
      } else if (filter.resultType == 1) {
        return 'recent';
      } else if (filter.resultType == 2) {
        return 'popular';
      }
    }

    return null;
  }

  List<TweetData> _transformTweets(List<Tweet> tweets) {
    return tweets.map((Tweet tweet) => TweetData.fromTweet(tweet)).toList();
  }

  @override
  Stream<TweetSearchState> applyAsync({
    TweetSearchState currentState,
    TweetSearchBloc bloc,
  }) async* {
    final String searchQuery = _searchQuery();

    if (_unchangedQuery(searchQuery, currentState)) {
      _log.fine('search query does not differ from last query');
      return;
    }

    if (searchQuery != null) {
      _log.fine('searching tweets');

      yield const TweetSearchLoading();

      final List<TweetData> tweets = await bloc.searchService
          .searchTweets(
            q: searchQuery,
            count: 100,
            resultType: _resultType(),
          )
          .then((TweetSearch result) => _transformTweets(result.statuses))
          .catchError(twitterApiErrorHandler);

      if (tweets != null) {
        _log.fine('found ${tweets.length} tweets for query: $searchQuery');

        yield TweetSearchResult(
          filter: filter,
          searchQuery: searchQuery,
          tweets: tweets,
        );
      } else {
        yield TweetSearchFailure(searchQuery: searchQuery);
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
    TweetSearchState currentState,
    TweetSearchBloc bloc,
  }) async* {
    if (currentState is TweetSearchFailure) {
      bloc.add(SearchTweets(
        query: currentState.searchQuery,
        filter: currentState.filter,
      ));
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
    TweetSearchState currentState,
    TweetSearchBloc bloc,
  }) async* {
    yield const TweetSearchInitial();
  }
}
