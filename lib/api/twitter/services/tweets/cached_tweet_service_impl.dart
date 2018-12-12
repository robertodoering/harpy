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

    List<Tweet> tweets = [];
    tweets = await _tweetCache.checkCacheForTweets();

    if (tweets.isNotEmpty && !forceUpdate) {
      log.fine("Using cached data");
      return tweets;
    }

    log.fine("Force update cache: $forceUpdate");

    tweets = await super.getHomeTimeline(params: params);
    log.fine("Requested to Twitter API got ${tweets.length} records");

    _tweetCache.cacheTweets(tweets);
    log.fine("Store them on device");

    tweets = await _tweetCache.getCachedTweets();
    log.fine("Return everthing stored!");

    return tweets;
  }

  @override
  Future<Tweet> createTweet(String text) async {
    log.fine("Send Tweet to api");
    Tweet newTweet = await super.createTweet(text);

    log.fine("Cache new Tweet");
    _tweetCache.cacheTweet(newTweet);

    return newTweet;
  }

  void updateCache(Tweet tweet) async {
    log.fine("updating tweet");

    bool exists = await _tweetCache.tweetExists(tweet);

    if (exists) {
      log.fine("tweet updated");
      _tweetCache.cacheTweet(tweet);
      return;
    }

    log.warning("tweet unable to update");
  }
}
