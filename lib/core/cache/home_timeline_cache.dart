import 'package:harpy/core/cache/tweet_cache.dart';

class HomeTimelineCache extends TweetCache {
  HomeTimelineCache() {
    data.type = homeTimeline;
  }

  static const String homeTimeline = "home_timeline";
}
