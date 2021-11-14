import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class HomeTimelineCubit extends TimelineCubit {
  HomeTimelineCubit() {
    filter = TimelineFilter.fromJsonString(
      app<TimelineFilterPreferences>().homeTimelineFilter,
    );
  }

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return app<TwitterApi>().timelineService.homeTimeline(
          count: 200,
          sinceId: sinceId,
          maxId: maxId,
          excludeReplies: filter.excludesReplies,
        );
  }

  @override
  bool get restoreInitialPosition =>
      app<GeneralPreferences>().keepLastHomeTimelinePosition;

  @override
  int get restoredTweetId => app<TweetVisibilityPreferences>().lastVisibleTweet;

  @override
  void persistFilter(String encodedFilter) {
    app<TimelineFilterPreferences>().homeTimelineFilter = encodedFilter;
  }

  void addTweet(TweetData tweet) {
    final currentState = state;

    if (currentState is TimelineStateData) {
      final tweets = List.of(currentState.tweets);

      if (tweet.parentTweetId == null) {
        tweets.insert(0, tweet);
      }

      emit(
        currentState.copyWith(
          tweets: tweets.toBuiltList(),
          isInitialResult: false,
        ),
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

      emit(
        currentState.copyWith(
          tweets: tweets.toBuiltList(),
          isInitialResult: false,
        ),
      );
    }
  }
}
