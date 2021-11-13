import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class UserTimelineCubit extends TimelineCubit {
  UserTimelineCubit({
    required this.handle,
  }) {
    filter = TimelineFilter.fromJsonString(
      app<TimelineFilterPreferences>().userTimelineFilter,
    );

    loadInitial();
  }

  final String? handle;

  @override
  void persistFilter(String encodedFilter) {
    app<TimelineFilterPreferences>().userTimelineFilter = encodedFilter;
  }

  @override
  Future<List<Tweet>> request({String? sinceId, String? maxId}) {
    return app<TwitterApi>().timelineService.userTimeline(
          screenName: handle,
          count: 200,
          sinceId: sinceId,
          maxId: maxId,
          excludeReplies: filter.excludesReplies,
        );
  }

  @override
  bool get restoreInitialPosition => false;

  @override
  int get restoredTweetId => 0;
}
