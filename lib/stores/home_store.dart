import 'dart:convert';

import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweets/cached_tweet_service_impl.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service_impl.dart';
import 'package:harpy/core/cache/tweet_cache.dart';

class HomeStore extends Store {
  static final Action initTweets = Action();
  static final Action updateTweets = Action();
  static final Action clearCache = Action();
  static final Action<String> tweetsAfter = Action();

  static final Action<Tweet> favoriteTweet = Action();
  static final Action<Tweet> unfavoriteTweet = Action();
  static final Action<Tweet> retweetTweet = Action();
  static final Action<Tweet> unretweetTweet = Action();

  static final Action<Tweet> showTweetMedia = Action();
  static final Action<Tweet> hideTweetMedia = Action();

  List<Tweet> _tweets;

  List<Tweet> get tweets => _tweets;

  HomeStore() {
    initTweets.listen((_) async {
      _tweets = await CachedTweetServiceImpl().getHomeTimeline();
    });

    triggerOnAction(updateTweets, (_) async {
      _tweets = await CachedTweetServiceImpl().getHomeTimeline(
        forceUpdate: true,
      );
    });

    triggerOnAction(tweetsAfter, (String id) async {
      _tweets = await CachedTweetServiceImpl().getHomeTimeline(
        params: {"max_id": id},
        forceUpdate: true,
      );
    });

    clearCache.listen((_) => TweetCache().clearCache());

    // favorite / retweet actions
    triggerOnAction(favoriteTweet, (Tweet tweet) {
      tweet.favorited = true;
      tweet.favoriteCount++;

      TweetServiceImpl().favorite(tweet.idStr)
        ..then((_) {
          CachedTweetServiceImpl().updateCache(tweet);
        })
        ..catchError((error) {
          if (!_actionPerformed(error)) {
            tweet.favorited = false;
            tweet.favoriteCount--;
          }
        });
    });

    triggerOnAction(unfavoriteTweet, (Tweet tweet) {
      tweet.favorited = false;
      tweet.favoriteCount--;

      TweetServiceImpl().unfavorite(tweet.idStr)
        ..then((_) {
          CachedTweetServiceImpl().updateCache(tweet);
        })
        ..catchError((error) {
          if (!_actionPerformed(error)) {
            tweet.favorited = true;
            tweet.favoriteCount++;
          }
        });
      ;
    });

    triggerOnAction(retweetTweet, (Tweet tweet) {
      tweet.retweeted = true;
      tweet.retweetCount++;

      TweetServiceImpl().retweet(tweet.idStr)
        ..then((_) {
          CachedTweetServiceImpl().updateCache(tweet);
        })
        ..catchError((error) {
          if (!_actionPerformed(error)) {
            tweet.retweeted = false;
            tweet.retweetCount--;
          }
        });
    });

    triggerOnAction(unretweetTweet, (Tweet tweet) {
      tweet.retweeted = false;
      tweet.retweetCount--;

      TweetServiceImpl().unretweet(tweet.idStr)
        ..then((_) {
          CachedTweetServiceImpl().updateCache(tweet);
        })
        ..catchError((error) {
          if (!_actionPerformed(error)) {
            tweet.retweeted = true;
            tweet.retweetCount++;
          }
        });
    });

    showTweetMedia.listen((Tweet tweet) {
      tweet.harpyData.showMedia = true;

      CachedTweetServiceImpl().updateCache(tweet);
    });

    hideTweetMedia.listen((Tweet tweet) {
      tweet.harpyData.showMedia = false;

      CachedTweetServiceImpl().updateCache(tweet);
    });
  }

  /// Returns `true` if the error contains any of the following error codes:
  ///
  /// 139: already favorited (trying to favorite a tweet twice)
  /// 327: already retweeted
  /// 144: tweet with id not found (trying to unfavorite a tweet twice)
  bool _actionPerformed(error) {
    try {
      List errors = jsonDecode(error)["errors"];
      return errors.any((error) =>
          error["code"] == 139 || // already favorited
          error["code"] == 327 || // already retweeted
          error["code"] == 144); // not found
    } on Exception {
      // unexpected error format
      return false;
    }
  }
}
