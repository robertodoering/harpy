import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service_impl.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:logging/logging.dart';

class CachedTweetServiceImpl extends TweetServiceImpl implements TweetService {
  final Logger log = Logger('CachedTweetServiceImpl');

  TweetCache _tweetCache = TweetCache();

  @override
  Future<List<Tweet>> getHomeTimeline({
    Map<String, String> params,
    bool forceUpdate = false,
  }) async {
    log.finest("Trying to get Home Timeline Data");

    List<Tweet> tweets = await _tweetCache.checkCacheForTweets();

    if (tweets.isNotEmpty && !forceUpdate) {
      log.fine("Using cached data");
      return tweets;
    }

    log.fine("Force update cache");

    tweets = await super.getHomeTimeline(params: params);
    // todo: when request fails return cached tweets
    log.fine("Requested to Twitter API, got ${tweets.length} records");

    log.fine("Store them on device");
    _tweetCache.updateCachedTweets(tweets);

    // sort tweets by id
    tweets.sort((t1, t2) => t2.id - t1.id);

    return tweets;
  }

  void updateCache(Tweet tweet) async {
    log.fine("updating tweet");

    bool exists = await _tweetCache.tweetExists(tweet);

    if (exists) {
      _tweetCache.cacheTweet(tweet);
      log.fine("tweet updated");
    } else {
      log.warning("tweet not found in cache");
    }
  }
}
