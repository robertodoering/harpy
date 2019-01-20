import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:harpy/models/timeline_model.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class HomeTimelineModel extends TimelineModel {
  HomeTimelineModel({
    @required TweetService tweetService,
    @required TweetCache tweetCache,
  }) : super(tweetService: tweetService, tweetCache: tweetCache);

  static final Logger _log = Logger("HomeTimelineModel");

  @override
  Future<void> updateTweets() async {
    _log.fine("updating tweets");
    tweets = await tweetService.getHomeTimeline();
    notifyListeners();
  }
}
