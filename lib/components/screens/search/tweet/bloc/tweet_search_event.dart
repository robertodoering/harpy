part of 'tweet_search_bloc.dart';

abstract class TweetSearchEvent {
  const TweetSearchEvent();

  Future<void> handle(TweetSearchBloc bloc, Emitter emit);
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
class SearchTweets extends TweetSearchEvent with HarpyLogger {
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
  Future<void> handle(TweetSearchBloc bloc, Emitter emit) async {
    final query = _searchQuery();

    if (_unchangedQuery(query, bloc.state)) {
      log.fine('search query does not differ from last query');
      return;
    }

    if (query != null) {
      log.fine('searching tweets');

      emit(TweetSearchLoading(query: query));

      final tweets = await app<TwitterApi>()
          .tweetSearchService
          .searchTweets(
            q: query,
            count: 100,
            resultType: _resultType(),
          )
          .then((result) => _transformTweets(result.statuses!))
          .handleError(twitterApiErrorHandler);

      if (tweets != null) {
        log.fine('found ${tweets.length} tweets for query: $query');

        emit(
          TweetSearchResult(
            filter: filter,
            query: query,
            tweets: tweets,
          ),
        );
      } else {
        emit(TweetSearchFailure(query: query, filter: filter));
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
  Future<void> handle(TweetSearchBloc bloc, Emitter emit) async {
    final state = bloc.state;

    if (state is TweetSearchFailure) {
      bloc.add(
        SearchTweets(
          customQuery: state.query,
          filter: state.filter,
        ),
      );
    }
  }
}

/// Yields a [TweetSearchInitial] to reset the bloc and clear any results.
class ClearSearchResult extends TweetSearchEvent {
  const ClearSearchResult();

  @override
  Future<void> handle(TweetSearchBloc bloc, Emitter emit) async {
    emit(const TweetSearchInitial());
  }
}
