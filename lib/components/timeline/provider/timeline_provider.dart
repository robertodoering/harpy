import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

part 'timeline_provider.freezed.dart';

/// Implements common functionality for notifiers that handle timelines.
///
/// Implementations can use the generic type to build their own custom data
/// which available in [TimelineStateData].
///
/// Listens to the [timelineFilterProvider] and updates the timeline when the
/// filter changes.
///
/// For example implementations, see:
/// * [HomeTimelineNotifier]
/// * [LikesTimelineNotifier]
/// * [ListTimelineNotifier]
/// * [MentionsTimelineNotifier]
/// * [UserTimelineNotifier]
abstract class TimelineNotifier<T extends Object>
    extends StateNotifier<TimelineState<T>> with RequestLock, LoggerMixin {
  TimelineNotifier({
    required this.ref,
    required this.twitterApi,
  }) : super(const TimelineState.initial()) {
    filter = currentFilter();

    ref.listen(
      timelineFilterProvider,
      (_, __) {
        // update and reload filter whenever it changes
        final newFilter = currentFilter();

        if (filter != newFilter) {
          log.fine('updated timeline filter');
          filter = newFilter;
          load(clearPrevious: true);
        }
      },
    );
  }

  @protected
  final Ref ref;

  @protected
  final TwitterApi twitterApi;

  TimelineFilter? filter;

  @protected
  TimelineFilter? currentFilter() => null;

  @protected
  Future<List<Tweet>> request({
    String? sinceId,
    String? maxId,
  });

  @protected
  bool get restoreInitialPosition => false;

  @protected
  bool get restoreRefreshPosition => false;

  @protected
  int get restoredTweetId => 0;

  @protected
  T? buildCustomData(BuiltList<LegacyTweetData> tweets) => null;

  Future<void> loadInitial() async {
    if (state is! TimelineStateInitial) return;
    log.fine('loading initial timeline');
    state = const TimelineState.loading();

    if (!restoreInitialPosition || restoredTweetId == 0) {
      // the timeline position either shouldn't be restored or the restored
      // tweet id is not available (= 0, e.g first open) -> load normally
      return load();
    }

    return loadAndRestore(restoredTweetId);
  }

  Future<void> load({
    bool clearPrevious = false,
  }) async {
    log.fine('loading timeline');

    final currentState = state;

    if (clearPrevious) {
      state = const TimelineState.loading();
    } else if (currentState is TimelineStateData<T> && restoreRefreshPosition) {
      final minId = currentState._requestMinId;
      if (minId != null) return loadAndRestore(minId);
    }

    String? maxId;

    final tweets = await request()
        .then((tweets) {
          if (tweets.isNotEmpty) maxId = tweets.last.idStr;
          return tweets;
        })
        .then((tweets) => handleTweets(tweets, filter))
        .handleError((e, st) => twitterErrorHandler(ref, e, st));

    if (tweets != null) {
      log.fine('found ${tweets.length} tweets');

      if (tweets.isNotEmpty) {
        state = TimelineState.data(
          tweets: tweets,
          maxId: maxId,
          customData: buildCustomData(tweets),
        );
      } else {
        state = const TimelineState.noData();
      }
    } else {
      state = const TimelineState.error();
    }
  }

  Future<void> loadOlder() async {
    if (lock()) return;

    final currentState = state;

    if (currentState is TimelineStateData<T>) {
      final maxId = currentState._requestMaxId;

      if (maxId == null) {
        log.info('tried to load older but max id was null');
        return;
      }

      log.fine('loading older timeline tweets');

      state = TimelineState.loadingMore(data: currentState);

      String? newMaxId;

      final tweets = await request(maxId: maxId)
          .then((tweets) {
            if (tweets.isNotEmpty) newMaxId = tweets.last.idStr;
            return tweets;
          })
          .then((tweets) => handleTweets(tweets, filter))
          .handleError((e, st) => twitterErrorHandler(ref, e, st));

      if (tweets != null) {
        log.fine('found ${tweets.length} older tweets');

        state = currentState.copyWith(
          tweets: currentState.tweets.followedBy(tweets).toBuiltList(),
          maxId: newMaxId,
          isInitialResult: false,
        );
      } else {
        // re-yield result state with previous tweets but new max id
        state = currentState.copyWith(
          maxId: newMaxId,
          isInitialResult: false,
        );
      }
    }
  }

  Future<void> loadAndRestore(int tweetId) async {
    final tweets = await _loadTweetsSince(tweetId);

    if (tweets.isNotEmpty) {
      log.fine('found ${tweets.length} tweets');

      final maxId = tweets.last.originalId;

      LegacyTweetData? restoredTweet;
      int? restoredTweetIndex;

      // find the tweet with `tweetId`, or the the next tweet that is newer that
      // `tweetId`
      for (var i = 0; i < tweets.length; i++) {
        final id = int.tryParse(tweets[i].originalId);
        if (id == null) continue;

        if (id >= tweetId) {
          restoredTweet = tweets[i];
          restoredTweetIndex = i;

          // Break when finding the exact tweet, otherwise look for an older one
          // that is still newer than `tweetId`.
          // This prevents refreshing to falsely identify older tweets as the
          // refreshTweet if the `tweetId` is from a Tweet that has replies
          // which pushed it up in the timeline.
          if (id == tweetId) break;
        } else {
          break;
        }
      }

      if (restoredTweetIndex != null && restoredTweetIndex > 1) {
        final data = TimelineStateData(
          tweets: tweets.sublist(0, restoredTweetIndex),
          maxId: maxId,
          initialResultsCount: restoredTweetIndex,
          initialResultsLastId: restoredTweet!.originalId,
          isInitialResult: true,
          customData: buildCustomData(tweets),
        );

        state = TimelineState.loadingMore(data: data);
        // wait to ensure that the jump in the timeline happened
        await Future<void>.delayed(const Duration(milliseconds: 1000));

        state = data.copyWith(
          tweets: data.tweets
              .followedBy(tweets.sublist(restoredTweetIndex))
              .toBuiltList(),
          maxId: maxId,
          isInitialResult: false,
        );
      } else {
        state = TimelineState.data(
          tweets: tweets,
          maxId: maxId,
          customData: buildCustomData(tweets),
        );
      }
    } else {
      state = const TimelineState.error();
    }
  }

  Future<BuiltList<LegacyTweetData>> _loadTweetsSince(int tweetId) async {
    final timeLineTweets = <LegacyTweetData>[];
    int? lastId;
    String? maxId;

    // request up to 600 tweets to find all tweets since `tweetId`
    for (var i = 0; i < 3 && (lastId == null || lastId > tweetId); i++) {
      if (lastId != null) maxId = '${lastId - 1}';

      final moreTweets = await request(maxId: maxId)
          .then((moreTweets) {
            if (moreTweets.isNotEmpty) maxId = moreTweets.last.idStr;
            return moreTweets;
          })
          .then((tweets) => handleTweets(tweets, filter))
          .handleError((e, st) => twitterErrorHandler(ref, e, st));

      if (moreTweets == null) break;

      timeLineTweets.addAll(moreTweets);
      lastId = int.tryParse(maxId ?? '');
    }

    return BuiltList.of(timeLineTweets);
  }
}

@freezed
class TimelineState<T extends Object> with _$TimelineState {
  const factory TimelineState.initial() = TimelineStateInitial;

  const factory TimelineState.loading() = TimelineStateLoading;

  const factory TimelineState.data({
    required BuiltList<LegacyTweetData> tweets,

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
    T? customData,
  }) = TimelineStateData;

  const factory TimelineState.noData() = TimelineStateNoData;

  const factory TimelineState.loadingMore({
    required TimelineStateData data,
  }) = TimelineStateLoadingOlder;

  const factory TimelineState.error() = TimelineStateError;
}

extension TimelineStateExtension on TimelineState {
  bool get canLoadMore => maybeMap(
        data: (value) => value.maxId != null && value.maxId != '0',
        orElse: () => false,
      );

  BuiltList<LegacyTweetData> get tweets => maybeMap(
        data: (value) => value.tweets,
        loadingMore: (value) => value.data.tweets,
        orElse: BuiltList.new,
      );

  int get initialResultsCount => maybeMap(
        data: (value) => value.initialResultsCount ?? 0,
        loadingMore: (value) => value.data.initialResultsCount ?? 0,
        orElse: () => 0,
      );

  bool showNewTweetsExist(String? originalIdStr) => maybeMap(
        data: (value) =>
            value.initialResultsLastId == originalIdStr &&
            value.initialResultsCount != null &&
            value.initialResultsCount! > 1,
        loadingMore: (value) =>
            value.data.initialResultsLastId == originalIdStr &&
            value.data.initialResultsCount != null &&
            value.data.initialResultsCount! > 1,
        orElse: () => false,
      );

  bool get scrollToEnd => maybeMap(
        data: (value) =>
            value.isInitialResult &&
            value.initialResultsCount != 0 &&
            value.initialResultsCount! > 0,
        loadingMore: (value) =>
            value.data.isInitialResult &&
            value.data.initialResultsCount != 0 &&
            value.data.initialResultsCount! > 0,
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

  int? get _requestMinId {
    final firstTweet = tweets.firstOrNull;
    if (firstTweet != null) {
      return int.tryParse(firstTweet.originalId);
    }
    return null;
  }
}
