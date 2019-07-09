import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/data/tweet_search.dart';
import 'package:harpy/api/twitter/service_utils.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/core/misc/isolate_work.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger("TweetSearchService");

class TweetSearchService {
  TweetSearchService({
    @required this.twitterClient,
  }) : assert(twitterClient != null);

  final TwitterClient twitterClient;

  /// Gets the replies to a [Tweet].
  Future<List<Tweet>> getReplies(Tweet tweet) async {
    _log.fine("get tweet replies");

    final replies = <Tweet>[];

    await for (final reply in _getRepliesRecursively(tweet)) {
      replies.add(reply);
    }

    _log.fine("got ${replies.length} total replies");

    return sortTweetReplies(replies);
  }

  /// Returns a stream of replies for the [tweet] that finishes once every
  /// reply has been found.
  ///
  /// Since twitter's api doesn't provide a way to get replies to a particular
  /// tweet we use a search query for replies to the [tweet]'s user and filter
  /// out once that aren't replies to the [tweet].
  ///
  /// For every reply we find we additionally look for all replies of that
  /// reply to get the complete chain of comments.
  ///
  /// This code is a modified version of a python library's solution to get
  /// replies to a particular tweet.
  /// https://gist.github.com/edsu/54e6f7d63df3866a87a15aed17b51eaf#file-replies-py-L4
  Stream<Tweet> _getRepliesRecursively(Tweet tweet) async* {
    final String user = tweet.user.screenName;
    final String tweetId = tweet.idStr;

    String maxId;
    int statuses;

    do {
      final params = <String, String>{
        "q": Uri.encodeQueryComponent("to:$user"),
        "since_id": tweetId,
        "count": "100",
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
          .then((response) {
        return isolateWork<String, TweetSearch>(
          callback: _handleTweetSearchResponse,
          message: response.body,
        );
      });

      _log.finer("found ${result.statuses.length} search results");

      for (final reply in result.statuses) {
        if (reply.inReplyToStatusIdStr == tweet.idStr) {
          _log.finer("found reply from ${reply.user.screenName}");

          yield reply;

          await for (final replyToReply in _getRepliesRecursively(reply)) {
            yield replyToReply;
          }
        }
      }

      maxId = result.searchMetadata.maxIdStr;

      statuses = result.statuses.length ?? 0;
    } while (statuses >= 100);
  }
}

/// Handles the tweet search response.
///
/// Used in an isolate.
TweetSearch _handleTweetSearchResponse(String body) {
  _log.fine("parsing tweet search");
  return TweetSearch.fromJson(jsonDecode(body));
}
