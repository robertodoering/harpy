import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

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
  int get restoredTweetId => 0;

  @protected
  T? buildCustomData(BuiltList<TweetData> tweets) => null;

  Future<void> loadInitial() async {
    if (state is! TimelineStateInitial) return;
    log.fine('loading initial timeline');
    state = const TimelineState.loading();

    if (!restoreInitialPosition || restoredTweetId == 0) {
      // the timeline position either shouldn't be restored or the restored
      // tweet id is not available (= 0, e.g first open) -> load normally
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
        .handleError(logErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} initial tweets');

      if (tweets.isNotEmpty) {
        state = TimelineState.data(
          tweets: tweets,
          maxId: maxId,
          initialResultsLastId: tweets.last.originalId,
          initialResultsCount: tweets.length - 1,
          isInitialResult: true,
          customData: buildCustomData(tweets),
        );

        // got initial tweets, load older
        await loadOlder();
      } else {
        // no initial tweets, load normally
        await load();
      }
    } else {
      state = const TimelineState.error();
    }
  }

  Future<void> load({
    bool clearPrevious = false,
  }) async {
    log.fine('loading timeline');

    if (clearPrevious) {
      state = const TimelineState.loading();
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
    if (lock()) {
      return;
    }

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
}

@freezed
class TimelineState<T extends Object> with _$TimelineState {
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

  BuiltList<TweetData> get tweets => maybeMap(
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
