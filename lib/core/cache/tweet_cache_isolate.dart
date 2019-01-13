import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/cache/tweet_cache.dart';

List<Tweet> updateCachedTweets(List<Tweet> tweets) {
  return TweetCache.initialized().updateCachedTweets(tweets);
}
