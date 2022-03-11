import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

part 'tweet_search_provider.freezed.dart';

final tweetSearchProvider = StateNotifierProvider.autoDispose
    .family<TweetSearchNotifier, TweetSearchState, String?>(
  (ref, initialQuery) => TweetSearchNotifier(
    read: ref.read,
    twitterApi: ref.watch(twitterApiProvider),
    initialQuery: initialQuery,
  ),
  name: 'TweetSearchProvider',
);

class TweetSearchNotifier extends StateNotifier<TweetSearchState>
    with LoggerMixin {
  TweetSearchNotifier({
    required Reader read,
    required TwitterApi twitterApi,
    required String? initialQuery,
  })  : _read = read,
        _twitterApi = twitterApi,
        super(const TweetSearchState.initial()) {
    if (initialQuery != null) search(customQuery: initialQuery);
  }

  final Reader _read;
  final TwitterApi _twitterApi;

  Future<void> search({
    String? customQuery,
    TweetSearchFilterData? filter,
  }) async {
    final query = customQuery ?? filter?.buildQuery();

    if (query == null || query.isEmpty) {
      log.warning('built search query is empty');
      return;
    }

    log.fine('searching tweets');

    state = TweetSearchState.loading(query: query, filter: filter);

    final tweets = await _twitterApi.tweetSearchService
        .searchTweets(
          q: query,
          count: 100,
          resultType: filter?.resultType.name,
        )
        .then(
          (result) => result.statuses?.map(TweetData.fromTweet).toBuiltList(),
        )
        .handleError((dynamic e, st) => twitterErrorHandler(_read, e, st));

    if (tweets != null) {
      if (tweets.isEmpty) {
        log.fine('found no tweets for query: $query');

        state = TweetSearchState.noData(query: query, filter: filter);
      } else {
        log.fine('found ${tweets.length} tweets for query: $query');

        state = TweetSearchState.data(
          tweets: tweets,
          query: query,
          filter: filter,
        );
      }
    } else {
      state = TweetSearchState.error(query: query, filter: filter);
    }
  }

  Future<void> refresh() {
    return search(
      customQuery: state.query,
      filter: state.filter,
    );
  }

  void clear() => state = const TweetSearchState.initial();
}

@freezed
class TweetSearchState with _$TweetSearchState {
  const factory TweetSearchState.initial() = _Initial;

  const factory TweetSearchState.loading({
    required String query,
    required TweetSearchFilterData? filter,
  }) = _Loading;

  const factory TweetSearchState.data({
    required BuiltList<TweetData> tweets,
    required String query,
    required TweetSearchFilterData? filter,
  }) = _Data;

  const factory TweetSearchState.noData({
    required String query,
    required TweetSearchFilterData? filter,
  }) = _NoData;

  const factory TweetSearchState.error({
    required String query,
    required TweetSearchFilterData? filter,
  }) = _Error;
}

extension TweetSearchStateExtension on TweetSearchState {
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

  TweetSearchFilterData? get filter => mapOrNull<TweetSearchFilterData?>(
        loading: (value) => value.filter,
        data: (value) => value.filter,
        noData: (value) => value.filter,
        error: (value) => value.filter,
      );
}
