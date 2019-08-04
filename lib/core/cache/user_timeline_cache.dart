import 'package:harpy/core/cache/tweet_cache.dart';

class UserTimelineCache extends TweetCache {
  UserTimelineCache() {
    data.type = userTimeline;
  }

  static const String userTimeline = "user_timeline";

  UserTimelineCache user(String userId) {
    data.userId = userId;
    return this;
  }
}
