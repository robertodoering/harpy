import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/twitter_service.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:harpy/core/cache/tweet_cache_isolate.dart';
import 'package:harpy/core/utils/isolate_work.dart';
import 'package:harpy/core/utils/json_mapper.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

final Logger _log = Logger("TweetService");

class TweetService extends TwitterService {
  TweetService({
    @required this.twitterClient,
    @required this.tweetCache,
  })  : assert(twitterClient != null),
        assert(tweetCache != null);

  final TwitterClient twitterClient;
  final TweetCache tweetCache;

  /// Returns a the home timeline for the logged in user.
  ///
  /// If the response status code is not 200 a [Future.error] is returned
  /// instead.
  Future<List<Tweet>> getHomeTimeline({
    Map<String, String> params,
  }) async {
    _log.fine("get home timeline");

    params ??= Map();
    params["count"] ??= "800"; // max: 800
    params["tweet_mode"] ??= "extended";

    final response = await twitterClient.get(
      "https://api.twitter.com/1.1/statuses/home_timeline.json",
      params: params,
    );

    if (response.statusCode == 200) {
      _log.fine("got response");

      // todo: handle all response in just one isolate

      // parse tweets
      List<Tweet> tweets = await isolateWork<String, List<Tweet>>(
        callback: _parseTweets,
        message: response.body,
      );

      // update cached home timeline tweets
//      tweets = await isolateWork<List<Tweet>, List<Tweet>>(
//        callback: updateCachedTweets,
//        message: tweets,
//        tweetCacheData: TweetCache.home().data, // todo: tweetcache
//      );

      _log.fine("got ${tweets.length} home timeline tweets");

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
    _log.fine("get user timeline");

    params ??= Map();
    params["count"] ??= "800";
    params["tweet_mode"] ??= "extended";
    params["user_id"] = userId;

    final response = await twitterClient.get(
      "https://api.twitter.com/1.1/statuses/user_timeline.json",
      params: params,
    );

    if (response.statusCode == 200) {
      _log.fine("got response");

      // todo: handle all response in just one isolate

      // parse tweets
      List<Tweet> tweets = await isolateWork<String, List<Tweet>>(
        callback: _parseTweets,
        message: response.body,
      );

      // copy over harpy data from cached home timeline tweets
      tweets = await isolateWork<List<Tweet>, List<Tweet>>(
        callback: _copyHomeHarpyData,
        message: tweets,
        tweetCacheData: TweetCache.home().data, // todo: tweetcache
      );

      // then update cached tweet for user
      isolateWork<List<Tweet>, void>(
        callback: updateCachedTweets,
        message: tweets,
        tweetCacheData: TweetCache.user(userId).data, // todo: tweetcache
      );

      return tweets;
    } else {
      return Future.error(response.body);
    }
  }

  /// Retweets the tweet with the [tweetId].
  Future retweet(String tweetId) async {
    final response = await twitterClient.post(
      "https://api.twitter.com/1.1/statuses/retweet/$tweetId.json",
    );

    return handleResponse(response);
  }

  /// Unretweets the tweet with the [tweetId].
  Future unretweet(String tweetId) async {
    final response = await twitterClient.post(
      "https://api.twitter.com/1.1/statuses/unretweet/$tweetId.json",
    );

    return handleResponse(response);
  }

  /// Favorites the tweet with the [tweetId].
  Future favorite(String tweetId) async {
    final response = await twitterClient.post(
      "https://api.twitter.com/1.1/favorites/create.json?id=$tweetId",
    );

    return handleResponse(response);
  }

  /// Unfavorites the tweet with the [tweetId].
  Future unfavorite(String tweetId) async {
    final response = await twitterClient.post(
      "https://api.twitter.com/1.1/favorites/destroy.json?id=$tweetId",
    );

    return handleResponse(response);
  }
}

List<Tweet> _parseTweets(String data) {
  _log.fine("parsing tweets");
  return mapJson(data, (json) => Tweet.fromJson(json));
}

List<Tweet> _copyHomeHarpyData(List<Tweet> tweets) {
  _log.fine("copy home harpy data");
  for (Tweet tweet in tweets) {
    Tweet homeTweet = TweetCache.initialized().getTweet("${tweet.id}");
    if (homeTweet != null) {
      tweet.harpyData = homeTweet.harpyData;
    }
  }

  return tweets;
}
