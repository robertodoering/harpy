import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger("TweetCacheIsolate");

List<Tweet> updateCachedTweets(List<Tweet> tweets) {
  _log.fine("updating cached tweets");
  return TweetCache.isolateInstance.updateCachedTweets(tweets);
}
