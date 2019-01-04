import 'dart:convert';

import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/translate/data/translation.dart';
import 'package:harpy/api/translate/translate_service.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:logging/logging.dart';

class HomeStore extends Store {
  final Logger log = Logger("HomeStore");

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

  static final Action<Tweet> translateTweet = Action();

  List<Tweet> _tweets;

  List<Tweet> get tweets => _tweets;

  HomeStore() {
    initTweets.listen((_) async {
      log.fine("init tweets");

      // initialize with cached tweets
      _tweets = await TweetCache.home().getCachedTweets();

      if (_tweets.isEmpty) {
        // if no cached tweet exists wait for the initial api call
        await updateTweets();
      } else {
        // if cached tweets exist update tweets but dont wait for it
        updateTweets();
      }
    });

    triggerOnAction(updateTweets, (_) async {
      log.fine("updating tweets");
      _tweets = await TweetService().getHomeTimeline();
    });

    triggerOnAction(tweetsAfter, (String id) async {
      id = (int.parse(id) - 1).toString();

      log.fine("getting tweets with max id $id");

      _tweets.addAll(await TweetService().getHomeTimeline(
        params: {"max_id": id},
      ));
    });

    clearCache.listen((_) => TweetCache.home().clearBucket());

    // favorite / retweet actions
    triggerOnAction(favoriteTweet, (Tweet tweet) {
      Tweet originalTweet = tweet;
      tweet = tweet.retweetedStatus ?? tweet;

      tweet.favorited = true;
      tweet.favoriteCount++;

      TweetService().favorite(tweet.idStr)
        ..then((_) {
          TweetCache.home().updateTweet(originalTweet);
        })
        ..catchError((error) {
          if (!_actionPerformed(error)) {
            tweet.favorited = false;
            tweet.favoriteCount--;
          }
        });
    });

    triggerOnAction(unfavoriteTweet, (Tweet tweet) {
      Tweet originalTweet = tweet;
      tweet = tweet.retweetedStatus ?? tweet;

      tweet.favorited = false;
      tweet.favoriteCount--;

      TweetService().unfavorite(tweet.idStr)
        ..then((_) {
          TweetCache.home().updateTweet(originalTweet);
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
      Tweet originalTweet = tweet;
      tweet = tweet.retweetedStatus ?? tweet;

      tweet.retweeted = true;
      tweet.retweetCount++;

      TweetService().retweet(tweet.idStr)
        ..then((_) {
          TweetCache.home().updateTweet(originalTweet);
        })
        ..catchError((error) {
          if (!_actionPerformed(error)) {
            tweet.retweeted = false;
            tweet.retweetCount--;
          }
        });
    });

    triggerOnAction(unretweetTweet, (Tweet tweet) {
      Tweet originalTweet = tweet;
      tweet = tweet.retweetedStatus ?? tweet;

      tweet.retweeted = false;
      tweet.retweetCount--;

      TweetService().unretweet(tweet.idStr)
        ..then((_) {
          TweetCache.home().updateTweet(originalTweet);
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

      TweetCache.home().updateTweet(tweet);
    });

    hideTweetMedia.listen((Tweet tweet) {
      tweet.harpyData.showMedia = false;

      TweetCache.home().updateTweet(tweet);
    });

    triggerOnAction(translateTweet, (Tweet tweet) async {
      Tweet originalTweet = tweet;
      tweet = tweet.retweetedStatus ?? tweet;

      Translation translation = await translate(text: tweet.full_text);

      originalTweet.harpyData.translation = translation;

      TweetCache.home().updateTweet(originalTweet);
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
