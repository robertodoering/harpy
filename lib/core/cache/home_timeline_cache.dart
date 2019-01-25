import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:harpy/core/filesystem/directory_service.dart';
import 'package:meta/meta.dart';

class HomeTimelineCache extends TweetCache {
  HomeTimelineCache({
    @required DirectoryService directoryService,
  }) : super(directoryService: directoryService) {
    data.type = homeTimeline;
  }

  static const String homeTimeline = "home_timeline";
}
