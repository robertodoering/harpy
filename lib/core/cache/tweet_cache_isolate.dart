import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/core/cache/tweet_cache.dart';

void updateCachedTweets(List<Tweet> tweets) {
  TweetCache.initialized().updateCachedTweets(tweets);
}
