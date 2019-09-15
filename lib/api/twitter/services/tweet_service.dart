import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/service_utils.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/core/utils/json_utils.dart';
import 'package:harpy/harpy.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger("TweetService");

/// Provides methods for making tweet and timeline related requests.
class TweetService {
  final TwitterClient twitterClient = app<TwitterClient>();

  /// Updates the current status of the authenticated user, also known as
  /// tweeting.
  Future<Tweet> updateStatus({
    String text,
    List<String> mediaIds,
  }) async {
    _log.fine("post a new tweet");

    final params = <String, String>{
      "tweet_mode": "extended",
    };

    final body = <String, String>{
      if (text != null) "status": text,
      if (mediaIds != null) "media_ids": mediaIds.join(","),
    };

    return twitterClient
        .post(
          "https://api.twitter.com/1.1/statuses/update.json",
          params: params,
          body: body,
        )
        .then(
          (response) => compute<String, Tweet>(
            _handleSingleTweetResponse,
            response.body,
          ),
        );
  }

  /// Returns a single [Tweet] for the [idStr].
  Future<Tweet> getTweet(String idStr) {
    _log.fine("get tweet with id $idStr");

    final params = <String, String>{
      "id": idStr,
      "include_entities": "true",
      "tweet_mode": "extended",
    };

    return twitterClient
        .get(
          "https://api.twitter.com/1.1/statuses/show.json",
          params: params,
        )
        .then(
          (response) => compute<String, Tweet>(
            _handleSingleTweetResponse,
            response.body,
          ),
        );
  }

  /// Returns a the home timeline for the logged in user.
  Future<List<Tweet>> getHomeTimeline({
    String maxId,
    Duration timeout,
  }) async {
    _log.fine("get home timeline");

    final params = <String, String>{
      "count": "200",
      "tweet_mode": "extended",
      if (maxId != null) "max_id": maxId,
    };

    return twitterClient
        .get(
          "https://api.twitter.com/1.1/statuses/home_timeline.json",
          params: params,
          timeout: timeout,
        )
        .then(
          (response) => compute<String, List<Tweet>>(
            _handleHomeTimelineResponse,
            response.body,
          ),
        );
  }

  /// Returns the user timeline for the [userId].
  Future<List<Tweet>> getUserTimeline(
    String userId, {
    String maxId,
    Duration timeout,
  }) async {
    _log.fine("get user timeline");

    final params = <String, String>{
      "user_id": userId,
      "count": "200",
      "tweet_mode": "extended",
      if (maxId != null) "max_id": maxId,
    };

    return twitterClient
        .get(
          "https://api.twitter.com/1.1/statuses/user_timeline.json",
          params: params,
          timeout: timeout,
        )
        .then(
          (response) => compute<String, List<Tweet>>(
            _handleUserTimelineResponse,
            response.body,
          ),
        );
  }

  /// Retweets the tweet with the [tweetId].
  Future<Response> retweet(String tweetId) async {
    _log.fine("retweet $tweetId");

    return twitterClient.post(
      "https://api.twitter.com/1.1/statuses/retweet/$tweetId.json",
    );
  }

  /// Unretweets the tweet with the [tweetId].
  Future<Response> unretweet(String tweetId) async {
    _log.fine("unretweet $tweetId");

    return twitterClient.post(
      "https://api.twitter.com/1.1/statuses/unretweet/$tweetId.json",
    );
  }

  /// Favorites the tweet with the [tweetId].
  Future<Response> favorite(String tweetId) async {
    _log.fine("favorite $tweetId");

    return twitterClient.post(
      "https://api.twitter.com/1.1/favorites/create.json?id=$tweetId",
    );
  }

  /// Unfavorites the tweet with the [tweetId].
  Future<Response> unfavorite(String tweetId) async {
    _log.fine("unfavorite $tweetId");

    return twitterClient.post(
      "https://api.twitter.com/1.1/favorites/destroy.json?id=$tweetId",
    );
  }
}

Tweet _handleSingleTweetResponse(String body) {
  _log.fine("parsing tweet");
  return Tweet.fromJson(jsonDecode(body));
}

/// Handles the home timeline response.
///
/// Used in an isolate.
List<Tweet> _handleHomeTimelineResponse(String body) {
  // parse tweets
  _log.fine("parsing tweets");
  final tweets = mapJson(body, (json) => Tweet.fromJson(json)) ?? [];

  // sort tweets
  return sortTweetReplies(tweets);
}

/// Handles the user timeline response.
///
/// Used in an isolate with the home timeline cache as cache data.
Future<List<Tweet>> _handleUserTimelineResponse(String body) async {
  // parse tweets
  _log.fine("parsing tweets");
  final tweets = mapJson(body, (json) => Tweet.fromJson(json)) ?? [];

  // sort tweets
  return sortTweetReplies(tweets);
}
