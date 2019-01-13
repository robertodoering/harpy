import 'package:flutter/foundation.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/twitter_service.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:harpy/core/filesystem/directory_service.dart';
import 'package:harpy/core/isolate/isolate_work.dart';
import 'package:harpy/core/json/json_mapper.dart';
import 'package:http/http.dart';

List<Tweet> parseTweets(String data) {
  return mapJson(data, (json) => Tweet.fromJson(json));
}

class TweetService extends TwitterService {
  /// Returns a the home timeline for the logged in user.
  ///
  /// If the response status code is not 200 a [Future.error] is returned
  /// instead.
  Future<List<Tweet>> getHomeTimeline({
    Map<String, String> params,
  }) async {
    log.fine("get home timeline");

    params ??= Map();
    params["count"] ??= "800"; // max: 800
    params["tweet_mode"] ??= "extended";

    final response = await TwitterClient().get(
      "https://api.twitter.com/1.1/statuses/home_timeline.json",
      params: params,
    );

    if (response.statusCode == 200) {
      log.fine("got response");
      List<Tweet> tweets = await isolateWork<String, List<Tweet>>(
        callback: parseTweets,
        message: response.body,
      );

      TweetCache.home().updateCachedTweets(tweets);

      return tweets;
    } else {
      return Future.error(response.body);
    }
  }

  /// Returns the user timeline for the [userId] or [screenName].
  Future<List<Tweet>> getUserTimeline(
    String userId, {
    Map<String, String> params,
  }) async {
    log.fine("get user timeline");

    params ??= Map();
    params["count"] ??= "800";
    params["tweet_mode"] ??= "extended";
    params["user_id"] = userId;

    Response response = await TwitterClient().get(
      "https://api.twitter.com/1.1/statuses/user_timeline.json",
      params: params,
    );

    if (response.statusCode == 200) {
      log.fine("got response");
      List<Tweet> tweets = await isolateWork<String, List<Tweet>>(
        callback: parseTweets,
        message: response.body,
      );

      // copy over harpy data from cached home timeline tweets
      // todo: isolate
      for (Tweet tweet in tweets) {
        Tweet homeTweet = TweetCache.home().getTweet("${tweet.id}");
        if (homeTweet != null) {
          tweet.harpyData = homeTweet.harpyData;
        }
      }

      // todo
      compute(isolateUpdateTweetCache, [
        tweets,
        TweetCache.user(userId).data,
        DirectoryService().data.path,
      ]).then((_) {
        print(" ++ TWEETS CACHED");
      });

      return tweets;
    } else {
      return Future.error(response.body);
    }
  }

  /// Retweets the tweet with the [tweetId].
  Future retweet(String tweetId) async {
    final response = await TwitterClient()
        .post("https://api.twitter.com/1.1/statuses/retweet/$tweetId.json");

    return handleResponse(response);
  }

  /// Unretweets the tweet with the [tweetId].
  Future unretweet(String tweetId) async {
    final response = await TwitterClient()
        .post("https://api.twitter.com/1.1/statuses/unretweet/$tweetId.json");

    return handleResponse(response);
  }

  /// Favorites the tweet with the [tweetId].
  Future favorite(String tweetId) async {
    final response = await TwitterClient()
        .post("https://api.twitter.com/1.1/favorites/create.json?id=$tweetId");

    return handleResponse(response);
  }

  /// Unfavorites the tweet with the [tweetId].
  Future unfavorite(String tweetId) async {
    final response = await TwitterClient()
        .post("https://api.twitter.com/1.1/favorites/destroy.json?id=$tweetId");

    return handleResponse(response);
  }
}
