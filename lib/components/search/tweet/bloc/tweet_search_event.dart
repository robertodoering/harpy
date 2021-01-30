part of 'tweet_search_bloc.dart';

abstract class TweetSearchEvent extends Equatable {
  const TweetSearchEvent();

  Stream<TweetSearchState> applyAsync({
    TweetSearchState currentState,
    TweetSearchBloc bloc,
  });
}

/// Searches tweets based on the [query] or the [filter].
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

  String _searchQuery() {
    if (query != null && query.isNotEmpty) {
      return query;
    } else if (filter != null) {
      final String filterQuery = filter.buildQuery();

      if (filterQuery != null && filterQuery.isNotEmpty) {
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
    _log.fine('searching tweets');

    // todo: do nothing if query is same as last

    final String searchQuery = _searchQuery();

    if (searchQuery != null) {
      yield const TweetSearchLoading();

      // todo: catch error 'filter too complex'
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
        // todo: yield error state
      }
    }
  }
}
