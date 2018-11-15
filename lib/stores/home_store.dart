import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweets/cached_tweet_service_impl.dart';
import 'package:harpy/core/cache/tweet_cache.dart';

class HomeStore extends Store {
  static final Action initTweets = Action();
  static final Action updateTweets = Action();
  static final Action clearCache = Action();

  static final Action<Tweet> favoriteTweet = Action();
  static final Action<Tweet> retweetTweet = Action();

  List<Tweet> _tweets;

  List<Tweet> get tweets => _tweets;

  HomeStore() {
    initTweets.listen((_) async {
      _tweets = await CachedTweetServiceImpl().getHomeTimeline();
    });

    triggerOnAction(updateTweets, (_) async {
      _tweets =
          await CachedTweetServiceImpl().getHomeTimeline(forceUpdate: true);
    });

    clearCache.listen((_) => TweetCache().clearCache());

    triggerOnAction(favoriteTweet, (Tweet tweet) {
      tweet.favorited = !tweet.favorited;

      if (tweet.favorited) {
        tweet.favoriteCount++;
      } else {
        tweet.favoriteCount--;
      }

      // todo: call to favorite / unfavorite tweet
      // don't await the api call, have a callback to revert the changes instead
    });

    triggerOnAction(retweetTweet, (Tweet tweet) {
      tweet.retweeted = !tweet.retweeted;

      if (tweet.retweeted) {
        tweet.retweetCount++;
      } else {
        tweet.retweetCount--;
      }

      // todo: call to retweet / unretweet tweet
    });
  }
}
