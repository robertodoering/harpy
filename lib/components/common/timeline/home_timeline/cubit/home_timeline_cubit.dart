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
  bool get restoreInitialPosition =>
      app<GeneralPreferences>().keepLastHomeTimelinePosition;

  @override
  int get restoredTweetId => app<TweetVisibilityPreferences>().lastVisibleTweet;

  @override
  void persistFilter(String encodedFilter) {
    app<TimelineFilterPreferences>().homeTimelineFilter = encodedFilter;
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

  void addTweet(TweetData tweet) {}

  void removeTweet(TweetData tweet) {}
}
