import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:harpy/core/misc/directory_service.dart';
import 'package:meta/meta.dart';

class UserTimelineCache extends TweetCache {
  UserTimelineCache({
    @required DirectoryService directoryService,
  }) : super(directoryService: directoryService) {
    data.type = userTimeline;
  }

  static const String userTimeline = "user_timeline";

  UserTimelineCache user(String userId) {
    data.userId = userId;
    return this;
  }
}
