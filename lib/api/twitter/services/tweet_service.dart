import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/service_utils.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/core/cache/home_timeline_cache.dart';
import 'package:harpy/core/cache/tweet_cache.dart';
import 'package:harpy/core/cache/tweet_cache_isolate.dart';
import 'package:harpy/core/cache/user_timeline_cache.dart';
import 'package:harpy/core/misc/directory_service.dart';
import 'package:harpy/core/misc/isolate_work.dart';
import 'package:harpy/core/misc/json_mapper.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

final Logger _log = Logger("TweetService");

/// Provides methods for making tweet and timeline related requests.
///
/// If a request times out or the response status code is not 200 a
/// [Future.error] is returned instead.
class TweetService {
  TweetService({
    @required this.directoryService,
    @required this.twitterClient,
    @required this.homeTimelineCache,
    @required this.userTimelineCache,
  })  : assert(directoryService != null),
        assert(twitterClient != null),
        assert(homeTimelineCache != null),
        assert(userTimelineCache != null);

  final DirectoryService directoryService;
  final TwitterClient twitterClient;
  final HomeTimelineCache homeTimelineCache;
  final UserTimelineCache userTimelineCache;

  /// Returns a the home timeline for the logged in user.
  Future<List<Tweet>> getHomeTimeline({
    Map<String, String> params,
  }) async {
    _log.fine("get home timeline");

    params ??= <String, String>{};
    params["count"] ??= "200"; // max: 200
    params["tweet_mode"] ??= "extended";

    return twitterClient
        .get(
      "https://api.twitter.com/1.1/statuses/home_timeline.json",
      params: params,
    )
        .then((response) {
      return isolateWork<String, List<Tweet>>(
        callback: _handleHomeTimelineResponse,
        message: response.body,
        tweetCacheData: homeTimelineCache.data,
        directoryServiceData: directoryService.data,
      );
    });
  }

  /// Returns the user timeline for the [userId].
  Future<List<Tweet>> getUserTimeline(
    String userId, {
    Map<String, String> params,
  }) async {
    _log.fine("get user timeline");

    params ??= <String, String>{};
    params["count"] ??= "200";
    params["tweet_mode"] ??= "extended";
    params["user_id"] = userId;

    return twitterClient
        .get(
      "https://api.twitter.com/1.1/statuses/user_timeline.json",
      params: params,
    )
        .then((response) async {
      final tweets = await isolateWork<String, List<Tweet>>(
        callback: _handleUserTimelineResponse,
        message: response.body,
        tweetCacheData: homeTimelineCache.data,
        directoryServiceData: directoryService.data,
      );

      return isolateWork<List<Tweet>, List<Tweet>>(
        callback: _handleUserTimelineTweetsCache,
        message: tweets,
        tweetCacheData: userTimelineCache.user(userId).data,
        directoryServiceData: directoryService.data,
      );
    });
  }

  /// Retweets the tweet with the [tweetId].
  Future<void> retweet(String tweetId) async {
    _log.fine("retweeting $tweetId");

    return await twitterClient.post(
      "https://api.twitter.com/1.1/statuses/retweet/$tweetId.json",
    );
  }

  /// Unretweets the tweet with the [tweetId].
  Future<void> unretweet(String tweetId) async {
    _log.fine("unretweet $tweetId");

    return await twitterClient.post(
      "https://api.twitter.com/1.1/statuses/unretweet/$tweetId.json",
    );
  }

  /// Favorites the tweet with the [tweetId].
  Future<void> favorite(String tweetId) async {
    _log.fine("favorite $tweetId");

    return await twitterClient.post(
      "https://api.twitter.com/1.1/favorites/create.json?id=$tweetId",
    );
  }

  /// Unfavorites the tweet with the [tweetId].
  Future<void> unfavorite(String tweetId) async {
    _log.fine("unfavorite $tweetId");

    return await twitterClient.post(
      "https://api.twitter.com/1.1/favorites/destroy.json?id=$tweetId",
    );
  }
}

/// Handles the home timeline response.
///
/// Used in an isolate.
List<Tweet> _handleHomeTimelineResponse(String body) {
  // parse tweets
  _log.fine("parsing tweets");
  List<Tweet> tweets = mapJson(body, (json) => Tweet.fromJson(json)) ?? [];
  _log.fine("parsed ${tweets.length} tweets");

  // sort tweets
  tweets = sortTweetReplies(tweets);

  // update cached home timeline tweets
  tweets = updateCachedTweets(tweets);

  tweets ??= [];
  _log.fine("got ${tweets.length} home timeline tweets");

  return tweets;
}

/// Handles the user timeline response.
///
/// Used in an isolate with the home timeline cache as cache data.
Future<List<Tweet>> _handleUserTimelineResponse(String body) async {
  // parse tweets
  _log.fine("parsing tweets");
  List<Tweet> tweets = mapJson(body, (json) => Tweet.fromJson(json)) ?? [];
  _log.fine("parsed ${tweets.length} tweets");

  // sort tweets
  tweets = sortTweetReplies(tweets);

  // copy over harpy data from cached home timeline tweets
  _log.fine("copy home harpy data");

  for (final tweet in tweets) {
    final homeTweet = TweetCache.isolateInstance.getTweet("${tweet.id}");
    if (homeTweet != null) {
      tweet.harpyData = homeTweet.harpyData;
    }
  }

  return tweets;
}

/// Handles the cache of the user timeline.
///
/// Used in an isolate with the user timeline cache of the user as the cache
/// data.
List<Tweet> _handleUserTimelineTweetsCache(List<Tweet> tweets) {
  // update cached tweets for user
  tweets = updateCachedTweets(tweets);

  tweets ??= [];
  _log.fine("got ${tweets.length} home timeline tweets");

  return tweets;
}
