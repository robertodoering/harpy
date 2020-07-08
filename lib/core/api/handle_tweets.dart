import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/core/api/tweet_data.dart';

/// Handles a tweet list response.
///
/// Every tweet is turned into a [TweetData] and their replies are added to
/// [TweetData.replies].
///
/// Only the parent [TweetData] of a reply chain will be in the returned list.
List<TweetData> handleTweets(List<Tweet> tweets) {
  final List<TweetData> tweetDataList = <TweetData>[];

  for (Tweet tweet in tweets.reversed) {
    if (tweet.inReplyToStatusIdStr != null) {
      // add child as reply to a parent tweet in the list
      if (!_addReplyChild(tweetDataList, tweet)) {
        // if parent not in list, add normally
        tweetDataList.insert(0, TweetData.fromTweet(tweet));
      }
    } else {
      // add tweet normally
      tweetDataList.insert(0, TweetData.fromTweet(tweet));
    }
  }

  return tweetDataList;
}

bool _addReplyChild(List<TweetData> tweetDataList, Tweet tweet) {
  for (TweetData tweetData in tweetDataList) {
    if (tweetData.idStr == tweet.inReplyToStatusIdStr) {
      // found parent tweet
      tweetData.replies.add(TweetData.fromTweet(tweet));
      return true;
    }
    // search for parent tweet in replies recursively
    if (tweetData.replies.isNotEmpty &&
        _addReplyChild(tweetData.replies, tweet)) {
      return true;
    }
  }

  return false;
}
