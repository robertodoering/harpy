import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/misc/misc.dart';

/// Handles a tweet list response in an isolate.
///
/// Every [Tweet] is turned into a [TweetData] and their replies are added to
/// [TweetData.replies].
///
/// Only the parent [TweetData] of a reply chain will be in the returned list.
Future<List<TweetData>> handleTweets(
  List<Tweet> tweets, [
  TimelineFilter? filter,
]) {
  return compute<List<dynamic>, List<TweetData>>(
    _isolateHandleTweets,
    <dynamic>[tweets, filter],
  );
}

List<TweetData> _isolateHandleTweets(List<dynamic> arguments) {
  final List<Tweet> tweets = arguments[0];
  final TimelineFilter? filter = arguments[1];

  final tweetDataList = tweets
      .where((tweet) => !_filterTweet(tweet, filter))
      .map((tweet) => TweetData.fromTweet(tweet))
      .toList();

  for (var i = 0; i < tweetDataList.length; i++) {
    final tweet = tweetDataList[i];

    if (tweet.parentTweetId != null) {
      // look for parent in older tweets
      for (var j = i; j < tweetDataList.length; j++) {
        final olderTweet = tweetDataList[j];

        if (olderTweet.id == tweet.parentTweetId) {
          // found parent tweet, remove child tweet from list and add it to
          //   the replies of the parent tweet
          tweetDataList[j] = olderTweet.copyWith(
            replies: [
              ...olderTweet.replies,
              tweet,
            ],
          );
          tweetDataList.removeAt(i);

          break;
        }
      }
    }
  }

  // sort to make sure the tweets are in chronological order with the newest
  //   reply to a tweet pushing the parent tweet to the front
  tweetDataList.sort((a, b) {
    final targetA = a.replies.isNotEmpty ? a.replies.first : a;
    final targetB = b.replies.isNotEmpty ? b.replies.first : b;
    final originalIdA = int.tryParse(targetA.originalId) ?? 0;
    final originalIdB = int.tryParse(targetB.originalId) ?? 0;

    return originalIdB.compareTo(originalIdA);
  });

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

      final hasImage = tweet.extendedEntities!.media!.first.type == kMediaPhoto;
      final hasGif = tweet.extendedEntities!.media!.first.type == kMediaGif;
      final hasVideo = tweet.extendedEntities!.media!.first.type == kMediaVideo;

      if (!(filter.includesImages && hasImage ||
          filter.includesGif && hasGif ||
          filter.includesVideo && hasVideo)) {
        return true;
      }
    }

    if (filter.excludesHashtags.isNotEmpty) {
      // filter tweets with hashtags

      final tweetHashtags = tweet.entities?.hashtags
              ?.map((hashtag) => hashtag.text?.toLowerCase() ?? '')
              .toList() ??
          <String>[];

      if (filter.excludesHashtags
          .map((hashtag) => removePrependedSymbol(
              hashtag.toLowerCase(), const <String>['#', '＃']))
          .any(tweetHashtags.contains)) {
        return true;
      }
    }

    if (filter.excludesPhrases.isNotEmpty) {
      // filter tweets with keywords / phrases
      final tweetText = tweet.fullText?.toLowerCase() ?? '';

      if (filter.excludesPhrases
          .map((phrase) => phrase.toLowerCase())
          .any(tweetText.contains)) {
        return true;
      }
    }

    return false;
  }
}
