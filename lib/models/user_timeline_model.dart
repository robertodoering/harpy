import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:harpy/models/timeline_model.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class UserTimelineModel extends TimelineModel {
  UserTimelineModel({
    @required this.userId,
    @required TweetService tweetService,
    @required TweetCache tweetCache,
  })  : assert(userId != null),
        super(tweetService: tweetService, tweetCache: tweetCache) {
    initTweets();
  }

  final String userId;

  static final Logger _log = Logger("UserTimelineModel");

  @override
  Future<void> initTweets() async {
    tweetCache.user(userId);
    return super.initTweets();
  }

  @override
  Future<void> updateTweets() async {
    _log.fine("updating tweets");
    loadingInitialTweets = tweets.isEmpty;
    notifyListeners();
    tweets = await tweetService.getUserTimeline(userId);
    loadingInitialTweets = false;
    notifyListeners();
  }

  @override
  Future<void> requestMore() async {
    await super.requestMore();

    String id = "${tweets.last.id - 1}";
    tweets.addAll(await tweetService.getUserTimeline(
      userId,
      params: {"max_id": id},
    ));

    requestingMore = false;
    notifyListeners();
  }
}
