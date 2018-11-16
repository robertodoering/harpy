import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweets/cached_tweet_service_impl.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service_impl.dart';
import 'package:harpy/core/cache/tweet_cache.dart';

class HomeStore extends Store {
  static final Action initTweets = Action();
  static final Action updateTweets = Action();
  static final Action clearCache = Action();

  static final Action<Tweet> favoriteTweet = Action();
  static final Action<Tweet> unfavoriteTweet = Action();
  static final Action<Tweet> retweetTweet = Action();
  static final Action<Tweet> unretweetTweet = Action();

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
      tweet.favorited = true;
      tweet.favoriteCount++;

      TweetServiceImpl().favorite(tweet.idStr);
      // todo: catch error and unfavorite again
      // unless error is
      // {"errors":[{"code":139,"message":"You have already favorited this status."}]}
    });

    triggerOnAction(unfavoriteTweet, (Tweet tweet) {
      tweet.favorited = false;
      tweet.favoriteCount--;

      TweetServiceImpl().unfavorite(tweet.idStr);
    });

    triggerOnAction(retweetTweet, (Tweet tweet) {
      tweet.retweeted = true;
      tweet.retweetCount++;

      TweetServiceImpl().retweet(tweet.idStr).catchError(() {
        tweet.retweeted = false;
        tweet.retweetCount--;
      });
    });

    triggerOnAction(unretweetTweet, (Tweet tweet) {
      tweet.retweeted = false;
      tweet.retweetCount--;

      TweetServiceImpl().unretweet(tweet.idStr).catchError(() {
        tweet.retweeted = true;
        tweet.retweetCount++;
      });
    });
  }
}
