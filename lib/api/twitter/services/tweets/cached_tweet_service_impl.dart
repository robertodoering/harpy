import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service_impl.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:logging/logging.dart';

class CachedTweetServiceImpl extends TweetServiceImpl implements TweetService {
  final Logger log = Logger('CachedTweetServiceImpl');

  TweetCache _tweetCache;

  CachedTweetServiceImpl() {
    _tweetCache = TweetCache();
  }

  @override
  Future<List<Tweet>> getHomeTimeline() async {
    log.finest("Tryin to get Home Timeline Data");
    List<Tweet> tweets = [];
    tweets = await _tweetCache.checkCacheForTweets();

    if (tweets.isNotEmpty) {
      log.fine("Using cached data");
      return tweets;
    }
    tweets = await super.getHomeTimeline();
    log.fine("Requested to Twitter API got ${tweets.length} records");

    _tweetCache.cacheTweets(tweets);
    log.fine("Store them on device");

    return tweets;
  }
}
