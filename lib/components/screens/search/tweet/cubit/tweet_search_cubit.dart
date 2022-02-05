import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'tweet_search_cubit.freezed.dart';

class TweetSearchCubit extends Cubit<NewTweetSearchState> with HarpyLogger {
  TweetSearchCubit({
    String? initialQuery,
  }) : super(const NewTweetSearchState.initial()) {
    if (initialQuery != null) {
      search(customQuery: initialQuery);
    }
  }

  Future<void> search({
    String? customQuery,
    TweetSearchFilter? filter,
  }) async {
    final query = _searchQuery(
      customQuery: customQuery,
      filter: filter,
    );

    if (query != null) {
      if (_queryUnchanged(query: query, filter: filter)) {
        log.fine('search does not differ from last query');
        return;
      }

      log.fine('searching tweets');

      emit(NewTweetSearchState.loading(query: query));

      final tweets = await app<TwitterApi>()
          .tweetSearchService
          .searchTweets(
            q: query,
            count: 100,
            resultType: _resultType(filter),
          )
          .then(
            (result) => result.statuses!.map(TweetData.fromTweet).toBuiltList(),
          )
          .handleError(twitterApiErrorHandler);

      if (tweets != null) {
        if (tweets.isEmpty) {
          log.fine('found no tweets for query: $query');

          emit(
            NewTweetSearchState.noData(
              query: query,
              filter: filter,
            ),
          );
        } else {
          log.fine('found ${tweets.length} tweets for query: $query');

          emit(
            NewTweetSearchState.data(
              tweets: tweets,
              query: query,
              filter: filter,
            ),
          );
        }
      } else {
        emit(NewTweetSearchState.error(query: query));
      }
    }
  }

  void clear() {
    emit(const NewTweetSearchState.initial());
  }

  String? _searchQuery({
    String? customQuery,
    TweetSearchFilter? filter,
  }) {
    if (customQuery != null && customQuery.trim().isNotEmpty) {
      return customQuery.trim();
    } else if (filter != null) {
      final filterQuery = filter.buildQuery();

      if (filterQuery.trim().isNotEmpty) {
        return filterQuery.trim();
      }
    }

    return null;
  }

  bool _queryUnchanged({
    required String? query,
    required TweetSearchFilter? filter,
  }) {
    return state.maybeMap(
      data: (value) => value.query == query && value.filter == filter,
      orElse: () => false,
    );
  }

  String? _resultType(TweetSearchFilter? filter) {
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
}

@freezed
class NewTweetSearchState with _$NewTweetSearchState {
  const factory NewTweetSearchState.initial() = _Initial;
  const factory NewTweetSearchState.loading({required String query}) = _Loading;

  const factory NewTweetSearchState.data({
    required BuiltList<TweetData> tweets,

    /// The query that was used in the search request.
    ///
    /// Either built from the filter or manually entered by the user.
    required String query,
    TweetSearchFilter? filter,
  }) = _Data;

  const factory NewTweetSearchState.noData({
    required String query,
    TweetSearchFilter? filter,
  }) = _NoData;

  const factory NewTweetSearchState.error({
    required String query,
    TweetSearchFilter? filter,
  }) = _Error;
}

extension TweetSearchStateExtension on NewTweetSearchState {
  bool get hasData => this is _Data;

  BuiltList<TweetData> get tweets => maybeMap(
        data: (value) => value.tweets,
        orElse: BuiltList.new,
      );

  String? get query => mapOrNull(
        data: (value) => value.query,
        noData: (value) => value.query,
        loading: (value) => value.query,
        error: (value) => value.query,
      );

  TweetSearchFilter? get filter => mapOrNull<TweetSearchFilter?>(
        data: (value) => value.filter,
        noData: (value) => value.filter,
        error: (value) => value.filter,
      );
}
