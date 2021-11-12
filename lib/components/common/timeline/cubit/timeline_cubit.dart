import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'timeline_cubit.freezed.dart';

/// Implements common functionality for cubits that handle timelines.
///
/// For example implementations, see:
/// * [HomeTimelineCubit]
/// * [LikesTimelineCubit]
abstract class TimelineCubit extends Cubit<TimelineState>
    with RequestLock, HarpyLogger {
  TimelineCubit() : super(const TimelineState.initial());

  TimelineFilter filter = TimelineFilter.empty;

  bool get restoreInitialPosition;
  int get restoredTweetId;

  @protected
  void persistFilter(String encodedFilter);

  @protected
  Future<List<Tweet>> request({
    String? sinceId,
    String? maxId,
  });

  Future<void> loadInitial() async {
    log.fine('loading initial timeline');
    emit(const TimelineState.loading());

    if (!restoreInitialPosition || restoredTweetId == 0) {
      // the timeline either shouldn't be restored or the restored tweet id is
      // notvailable (= 0, e.g first open) -> load normally
      return load();
    }

    String? maxId;

    final tweets = await request(sinceId: '${restoredTweetId - 1}')
        .then((tweets) {
          if (tweets.isNotEmpty) {
            maxId = tweets.last.idStr;
          }
          return tweets;
        })
        .then((tweets) => handleTweets(tweets, filter))
        .handleError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} initial tweets');

      if (tweets.isNotEmpty) {
        emit(
          TimelineState.data(
            tweets: tweets.toBuiltList(),
            maxId: maxId,
            initialResultsLastId: tweets.last.originalId,
            initialResultsCount: tweets.length - 1,
            isInitialResult: true,
          ),
        );

        // got initial tweets, load older
        await loadOlder();
      } else {
        // no initial tweets, load normally
        await load();
      }
    } else {
      emit(const TimelineState.error());
    }
  }

  Future<void> load({
    bool clearPrevious = false,
  }) async {
    log.fine('loading timeline');

    if (clearPrevious) {
      emit(const TimelineState.loading());
    }

    String? maxId;

    final tweets = await request()
        .then((tweets) {
          if (tweets.isNotEmpty) {
            maxId = tweets.last.idStr;
          }
          return tweets;
        })
        .then(
          (tweets) => handleTweets(tweets, filter),
        )
        .handleError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} tweets');

      if (tweets.isNotEmpty) {
        emit(
          TimelineState.data(
            tweets: tweets.toBuiltList(),
            maxId: maxId,
          ),
        );
      } else {
        emit(const TimelineState.noData());
      }
    } else {
      emit(const TimelineState.error());
    }
  }

  Future<void> loadOlder() async {
    if (lock()) {
      return;
    }

    final currentState = state;

    if (currentState is TimelineStateData) {
      final maxId = currentState._requestMaxId;

      if (maxId == null) {
        log.info('tried to load older but max id was null');
        return;
      }

      log.fine('loading older timeline tweets');

      emit(TimelineState.loadingMore(data: currentState));

      String? newMaxId;

      final tweets = await request(maxId: maxId)
          .then((tweets) {
            if (tweets.isNotEmpty) {
              newMaxId = tweets.last.idStr;
            }

            return tweets;
          })
          .then((tweets) => handleTweets(tweets, filter))
          .handleError(twitterApiErrorHandler);

      if (tweets != null) {
        log.fine('found ${tweets.length} older tweets');

        emit(
          currentState.copyWith(
            tweets: currentState.tweets.followedBy(tweets).toBuiltList(),
            maxId: newMaxId,
            isInitialResult: false,
          ),
        );
      } else {
        // re-yield result state with previous tweets but new max id
        emit(
          currentState.copyWith(
            maxId: newMaxId,
            isInitialResult: false,
          ),
        );
      }
    }
  }

  void applyFilter(TimelineFilter timelineFilter) {
    log.fine('set home timeline filter');

    try {
      final encodedFilter = jsonEncode(timelineFilter.toJson());
      log.finer('saving filter: $encodedFilter');

      persistFilter(encodedFilter);
    } catch (e, st) {
      log.warning('unable to encode timeline filter', e, st);
    }

    filter = timelineFilter;
    load(clearPrevious: true);
  }
}

@freezed
class TimelineState with _$TimelineState {
  const factory TimelineState.initial() = TimelineStateInitial;

  const factory TimelineState.loading() = TimelineStateLoading;

  const factory TimelineState.data({
    required BuiltList<TweetData> tweets,

    /// The max id used to request older tweets.
    ///
    /// This is the id of the last requested tweet before the tweets got
    /// filtered.
    required String? maxId,

    /// The idStr of that last tweet from the initial request.
    String? initialResultsLastId,

    /// The number of new tweets if the initial request found new tweets that
    /// were not present in a previous session.
    int? initialResultsCount,

    /// Whether we requested the initial home timeline with tweets that are
    /// newer than the last visible tweet from a previous session.
    @Default(false) bool isInitialResult,
  }) = TimelineStateData;

  const factory TimelineState.noData() = TimelineStateNoData;

  const factory TimelineState.loadingMore({
    required TimelineStateData data,
  }) = TimelineStateLoadingOlder;

  const factory TimelineState.error() = TimelineStateError;
}

extension TimelineStateExtension on TimelineState {
  bool get hasTweets => tweets.isNotEmpty;

  bool get canLoadMore => maybeMap(
        data: (data) => data.maxId != null && data.maxId != '0',
        orElse: () => false,
      );

  BuiltList<TweetData> get tweets => maybeMap(
        data: (value) => value.tweets,
        loadingMore: (value) => value.data.tweets,
        orElse: () => BuiltList(),
      );

  int get initialResultsCount => maybeMap(
        data: (value) => value.initialResultsCount ?? 0,
        loadingMore: (value) => value.data.initialResultsCount ?? 0,
        orElse: () => 0,
      );

  bool showNewTweetsExist(String? originalIdStr) => maybeMap(
        data: (value) => value.initialResultsLastId == originalIdStr,
        loadingMore: (value) =>
            value.data.initialResultsLastId == originalIdStr,
        orElse: () => false,
      );

  bool get scrollToEnd => maybeMap(
        data: (value) =>
            value.isInitialResult &&
            value.initialResultsCount != 0 &&
            value.initialResultsCount! > 0,
        orElse: () => false,
      );
}

extension on TimelineStateData {
  String? get _requestMaxId {
    final lastId = int.tryParse(maxId ?? '');

    if (lastId != null) {
      return '${lastId - 1}';
    } else {
      return null;
    }
  }
}
