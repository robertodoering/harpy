import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/tweet_search.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/api/twitter/error_handler.dart';
import 'package:harpy/api/twitter/service_utils.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/harpy.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger("TweetSearchService");

class TweetSearchService {
  final TwitterClient twitterClient = app<TwitterClient>();

  /// Gets all the replies to a [Tweet].
  ///
  /// All replies to the [tweet] from the last 7 days will be retrieved.
  ///
  /// To get all replies for a [Tweet], all replies to any [Tweet] from a [User]
  /// will have to be retrieved first and only 100 can be retrieved at a time.
  /// This means it is very expensive when a lot of replies are made to a
  /// [User].
  ///
  /// Deprecated because [getReplies] should be used instead.
  /// Not used anymore but kept in case we might want to use it again in a
  /// different use case in the future.
  @deprecated
  Future<List<Tweet>> getAllReplies(Tweet tweet) async {
    _log.fine("get all tweet replies");

    final replies = <Tweet>[];

    await for (final reply in _getAllRepliesRecursively(tweet)) {
      replies.add(reply);
    }

    _log.fine("got ${replies.length} total replies");

    return sortTweetReplies(replies);
  }

  /// Returns a stream of replies for the [tweet] that finishes once every
  /// reply has been found.
  ///
  /// Since Twitter's api doesn't provide a way to get replies to a particular
  /// tweet we use a search query for replies to the [tweet]'s user and filter
  /// out once that aren't replies to the [tweet].
  ///
  /// This code is a modified version of a python library's solution to get
  /// replies to a particular tweet.
  /// https://gist.github.com/edsu/54e6f7d63df3866a87a15aed17b51eaf#file-replies-py-L4
  ///
  /// Deprecated because [getReplies] should be used instead.
  /// Not used anymore but kept in case we might want to use it again in a
  /// different use case in the future.
  @deprecated
  Stream<Tweet> _getAllRepliesRecursively(Tweet tweet) async* {
    final String user = tweet.user.screenName;
    final String tweetId = tweet.idStr;

    String maxId;
    int statuses;

    do {
      final params = <String, String>{
        "q": Uri.encodeQueryComponent("to:$user"),
        "since_id": tweetId,
        "count": "100",
        "tweet_mode": "extended",
      };

      if (maxId != null) {
        params["max_id"] = maxId;
      }

      _log.fine("getting replies for $user");

      final TweetSearch result = await twitterClient
          .get(
            "https://api.twitter.com/1.1/search/tweets.json",
            params: params,
          )
          .then((response) => compute<String, TweetSearch>(
                _handleTweetSearchResponse,
                response.body,
              ))
          .catchError(twitterClientErrorHandler);

      if (result == null) {
        break;
      }

      _log.finer("found ${result.statuses.length} search results");

      for (final reply in result.statuses) {
        if (reply.inReplyToStatusIdStr == tweet.idStr) {
          _log.finer("found reply from ${reply.user.screenName}");

          yield reply;
        }

        maxId = reply.idStr;
      }

      statuses = result.statuses.length ?? 0;
    } while (statuses >= 100);
  }

  /// Returns a [TweetRepliesResult] that contains the found replies and
  /// information about the response.
  ///
  /// When the [lastResult] is included, only replies after the last response
  /// will be searched for.
  /// When [TweetRepliesResult.lastPage] is `true`, we expect that no more
  /// replies can be found.
  ///
  /// There is a chance that more replies can be found, because to retrieve
  /// the replies we get the last 100 user replies, filter those for the [tweet]
  /// and if the request didn't yield replies twice in a row we assume that
  /// we won't get any more.
  /// We could request until we received all of the user replies of the last
  /// 7 days to make sure every reply to the [tweet] has been found but that
  /// could mean many requests without any replies.
  Future<TweetRepliesResult> getReplies(
    Tweet tweet, {
    TweetRepliesResult lastResult,
  }) async {
    final String user = tweet.user.screenName;
    final String tweetId = tweet.idStr;

    final int maxId = lastResult == null ? null : lastResult.maxId + 1;

    final params = <String, String>{
      "q": Uri.encodeQueryComponent("to:$user"),
      "since_id": tweetId,
      "count": "100", // max 100
      "tweet_mode": "extended",
    };

    if (maxId != null) {
      params["max_id"] = "$maxId";
    }

    _log.fine("getting replies for $user");

    final TweetSearch result = await twitterClient
        .get(
          "https://api.twitter.com/1.1/search/tweets.json",
          params: params,
        )
        .then((response) => compute<String, TweetSearch>(
              _handleTweetSearchResponse,
              response.body,
            ))
        .catchError(twitterClientErrorHandler);

    if (result == null) {
      return null;
    }

    final List<Tweet> replies = [];

    // filter found tweets by replies
    for (final reply in result.statuses) {
      if (reply.inReplyToStatusIdStr == tweet.idStr) {
        _log.finer("found reply from ${reply.user.screenName}");

        replies.add(reply);
      }
    }

    _log.finer("found ${replies.length} replies");

    // expect no more replies exists if no replies in the last 2 requests have
    // been found
    final bool lastPage = result.statuses.length < 100 ||
        (lastResult != null && lastResult.replies.isEmpty && replies.isEmpty);

    return TweetRepliesResult(
      replies: replies,
      maxId: replies.isEmpty ? 0 : result.statuses.last.id,
      lastPage: lastPage,
    );
  }
}

/// Contains information for getting paginated replies for a [Tweet].
class TweetRepliesResult {
  const TweetRepliesResult({
    @required this.replies,
    @required this.maxId,
    @required this.lastPage,
  });

  /// The [Tweet]s that are replies to the requested [Tweet].
  ///
  /// This will most likely be a subset of the statuses from the
  /// [TweetSearch] response.
  final List<Tweet> replies;

  /// The id of the last retrieved [Tweet].
  final int maxId;

  /// A flag that is `true` when we assume we can't receive more replies.
  final bool lastPage;
}

/// Handles the tweet search response.
///
/// Used in an isolate.
TweetSearch _handleTweetSearchResponse(String body) {
  _log.fine("parsing tweet search");
  return TweetSearch.fromJson(jsonDecode(body));
}
