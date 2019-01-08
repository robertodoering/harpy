import 'dart:convert';

import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/translate/data/translation.dart';
import 'package:harpy/api/translate/translate_service.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';

typedef TweetChange(Tweet tweet);

mixin TweetStoreMixin on Store {
  TweetChange onTweetUpdated;

  void favoriteTweet(Tweet tweet) {
    Tweet originalTweet = tweet;
    tweet = tweet.retweetedStatus ?? tweet;

    tweet.favorited = true;
    tweet.favoriteCount++;

    TweetService().favorite(tweet.idStr)
      ..then((_) {
        if (onTweetUpdated != null) onTweetUpdated(originalTweet);
      })
      ..catchError((error) {
        if (!_actionPerformed(error)) {
          tweet.favorited = false;
          tweet.favoriteCount--;
        }
      });
  }

  void unfavoriteTweet(Tweet tweet) {
    Tweet originalTweet = tweet;
    tweet = tweet.retweetedStatus ?? tweet;

    tweet.favorited = false;
    tweet.favoriteCount--;

    TweetService().unfavorite(tweet.idStr)
      ..then((_) {
        if (onTweetUpdated != null) onTweetUpdated(originalTweet);
      })
      ..catchError((error) {
        if (!_actionPerformed(error)) {
          tweet.favorited = true;
          tweet.favoriteCount++;
        }
      });
  }

  void retweetTweet(Tweet tweet) {
    Tweet originalTweet = tweet;
    tweet = tweet.retweetedStatus ?? tweet;

    tweet.retweeted = true;
    tweet.retweetCount++;

    TweetService().retweet(tweet.idStr)
      ..then((_) {
        if (onTweetUpdated != null) onTweetUpdated(originalTweet);
      })
      ..catchError((error) {
        if (!_actionPerformed(error)) {
          tweet.retweeted = false;
          tweet.retweetCount--;
        }
      });
  }

  void unretweetTweet(Tweet tweet) {
    Tweet originalTweet = tweet;
    tweet = tweet.retweetedStatus ?? tweet;

    tweet.retweeted = false;
    tweet.retweetCount--;

    TweetService().unretweet(tweet.idStr)
      ..then((_) {
        if (onTweetUpdated != null) onTweetUpdated(originalTweet);
      })
      ..catchError((error) {
        if (!_actionPerformed(error)) {
          tweet.retweeted = true;
          tweet.retweetCount++;
        }
      });
  }

  void showTweetMedia(Tweet tweet) {
    tweet.harpyData.showMedia = true;

    if (onTweetUpdated != null) onTweetUpdated(tweet);
  }

  void hideTweetMedia(Tweet tweet) {
    tweet.harpyData.showMedia = false;

    if (onTweetUpdated != null) onTweetUpdated(tweet);
  }

  void translateTweet(Tweet tweet) async {
    Tweet originalTweet = tweet;
    tweet = tweet.retweetedStatus ?? tweet;

    Translation translation = await translate(text: tweet.full_text);

    originalTweet.harpyData.translation = translation;

    if (onTweetUpdated != null) onTweetUpdated(tweet);
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
