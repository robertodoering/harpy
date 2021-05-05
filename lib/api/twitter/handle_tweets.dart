import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/misc/misc.dart';

/// Handles a tweet list response.
///
/// Every [Tweet] is turned into a [TweetData] and their replies are added to
/// [TweetData.replies].
///
/// Only the parent [TweetData] of a reply chain will be in the returned list.
List<TweetData> handleTweets(List<Tweet> tweets, [TimelineFilter? filter]) {
  final List<TweetData> tweetDataList = <TweetData>[];

  for (Tweet tweet in tweets.reversed) {
    if (_filterTweet(tweet, filter)) {
      continue;
    }

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

bool _filterTweet(Tweet tweet, TimelineFilter? filter) {
  if (filter == null || filter == TimelineFilter.empty) {
    return false;
  } else {
    if (filter.excludesRetweets && tweet.retweetedStatus != null) {
      // filter retweets
      return true;
    }

    if (filter.includesImages || filter.includesGif || filter.includesVideo) {
      // filter non-media tweets
      if (tweet.extendedEntities?.media == null ||
          tweet.extendedEntities!.media!.isEmpty) {
        return true;
      }

      final bool hasImage =
          tweet.extendedEntities!.media!.first.type == kMediaPhoto;

      final bool hasGif =
          tweet.extendedEntities!.media!.first.type == kMediaGif;

      final bool hasVideo =
          tweet.extendedEntities!.media!.first.type == kMediaVideo;

      if (!(filter.includesImages && hasImage ||
          filter.includesGif && hasGif ||
          filter.includesVideo && hasVideo)) {
        return true;
      }
    }

    if (filter.excludesHashtags.isNotEmpty) {
      // filter tweets with hashtags

      final List<String> tweetHashtags = tweet.entities?.hashtags
              ?.map((Hashtag hashtag) => hashtag.text?.toLowerCase() ?? '')
              .toList() ??
          <String>[];

      if (filter.excludesHashtags
          .map((String hashtag) => removePrependedSymbol(
              hashtag.toLowerCase(), const <String>['#', '＃']))
          .any(tweetHashtags.contains)) {
        return true;
      }
    }

    if (filter.excludesPhrases.isNotEmpty) {
      // filter tweets with keywords / phrases
      final String tweetText = tweet.fullText?.toLowerCase() ?? '';

      if (filter.excludesPhrases
          .map((String phrase) => phrase.toLowerCase())
          .any(tweetText.contains)) {
        return true;
      }
    }

    return false;
  }
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
