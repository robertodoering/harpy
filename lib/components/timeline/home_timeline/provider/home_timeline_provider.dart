import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

final homeTimelineProvider =
    StateNotifierProvider.autoDispose<HomeTimelineNotifier, TimelineState>(
  (ref) => HomeTimelineNotifier(ref: ref),
  cacheTime: const Duration(minutes: 5),
  name: 'HomeTimelineProvider',
);

class HomeTimelineNotifier extends TimelineNotifier {
  HomeTimelineNotifier({
    required Ref ref,
  })  : _read = ref.read,
        super(ref: ref) {
    loadInitial();
  }

  final Reader _read;

  @override
  TimelineFilter? currentFilter() {
    final state = _read(timelineFilterProvider);
    return state.filterByUuid(state.activeHomeFilter()?.uuid);
  }

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return _read(twitterApiProvider).timelineService.homeTimeline(
          count: 200,
          sinceId: sinceId,
          maxId: maxId,
          excludeReplies: filter?.excludes.replies,
        );
  }

  @override
  bool get restoreInitialPosition =>
      _read(generalPreferencesProvider).keepLastHomeTimelinePosition;

  @override
  int get restoredTweetId =>
      _read(tweetVisibilityPreferencesProvider).lastVisibleTweet;

  void addTweet(TweetData tweet) {
    final currentState = state;

    if (currentState is TimelineStateData) {
      final tweets = List.of(currentState.tweets);

      if (tweet.parentTweetId == null) {
        tweets.insert(0, tweet);
      }

      // FIXME: when replying to a tweet add the new tweet as a reply to the
      //  existing parent

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
