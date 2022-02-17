import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final homeTimelineFilterProvider = Provider.autoDispose(
  (ref) {
    final state = ref.watch(timelineFilterProvider);
    return state.filterByUuid(state.activeHomeFilter()?.uuid);
  },
  name: 'HomeTimelineFilterProvider',
);

final homeTimelineProvider =
    StateNotifierProvider.autoDispose<HomeTimelineNotifier, TimelineState>(
  (ref) => HomeTimelineNotifier(ref: ref),
  name: 'HomeTimelineProvider',
);

class HomeTimelineNotifier extends TimelineNotifier {
  HomeTimelineNotifier({
    required Ref ref,
  })  : _reader = ref.read,
        super(ref: ref) {
    loadInitial();
  }

  final Reader _reader;

  @override
  TimelineFilter? currentFilter() {
    return _reader(homeTimelineFilterProvider);
  }

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return _reader(twitterApiProvider).timelineService.homeTimeline(
          count: 200,
          sinceId: sinceId,
          maxId: maxId,
          excludeReplies: filter?.excludes.replies,
        );
  }

  @override
  bool get restoreInitialPosition =>
      _reader(generalPreferencesProvider).keepLastHomeTimelinePosition;

  @override
  int get restoredTweetId =>
      _reader(tweetVisibilityPreferencesProvider).lastVisibleTweet;

  void addTweet(TweetData tweet) {
    final currentState = state;

    if (currentState is TimelineStateData) {
      final tweets = List.of(currentState.tweets);

      if (tweet.parentTweetId == null) {
        tweets.insert(0, tweet);
      }

      // TODO: when replying to a tweet add the new tweet as a reply

      currentState.copyWith(
        tweets: tweets.toBuiltList(),
        isInitialResult: false,
      );
    }
  }

  void removeTweet(TweetData tweet) {
    final currentState = state;

    if (currentState is TimelineStateData) {
      final tweets = List.of(currentState.tweets);

      if (tweet.parentTweetId == null) {
        tweets.removeWhere((element) => element.id == tweet.id);
      }

      state = currentState.copyWith(
        tweets: tweets.toBuiltList(),
        isInitialResult: false,
      );
    }
  }
}
