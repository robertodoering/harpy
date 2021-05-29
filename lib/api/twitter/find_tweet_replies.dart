import 'package:dart_twitter_api/api/tweets/tweet_search_service.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/api/api.dart';
import 'package:http/http.dart';

extension RepliesExtension on TweetSearchService {
  /// Returns a [RepliesResult] that contains paginated replies for the [tweet].
  ///
  /// When the [lastResult] is included, only replies after the last response
  /// will be searched for.
  ///
  /// When [RepliesResult.lastPage] is `true`, we assume that no more replies
  /// can be found.
  ///
  /// There is a chance that more replies can be found, because to retrieve
  /// the replies we get the last 100 user replies, filter those for the [tweet]
  /// and if the request didn't yield replies twice in a row we assume that
  /// we won't get any more.
  /// We could request until we received all of the user replies of the last
  /// 7 days to make sure every reply to the [tweet] has been found but that
  /// could mean many requests without any replies.
  ///
  /// Throws an exception when the [searchTweets] did not return a 200 response.
  Future<RepliesResult> findReplies(
    TweetData tweet,
    RepliesResult? lastResult,
  ) async {
    final screenName = tweet.user.handle;

    final maxId =
        lastResult == null ? null : '${int.tryParse(lastResult.maxId!)! + 1}';

    TweetSearch? result;

    try {
      result = await searchTweets(
        q: 'to:$screenName',
        sinceId: tweet.id,
        count: 100,
        maxId: maxId,
      );
    } catch (e) {
      // workaround for random 403 responses when querying with a since_id
      // https://github.com/robertodoering/harpy/issues/289
      if (e is Response && e.statusCode == 403) {
        result = await searchTweets(
          q: 'to:$screenName',
          count: 100,
          maxId: maxId,
        );
      } else {
        rethrow;
      }
    }

    final replies = <TweetData>[];

    // filter found tweets by replies
    for (final reply in result.statuses!) {
      if (reply.inReplyToStatusIdStr == tweet.id) {
        replies.add(TweetData.fromTweet(reply));
      }
    }

    // expect no more replies exists if no replies in the last 2 requests have
    // been found
    final lastPage = result.statuses!.length < 100 ||
        (lastResult?.replies != null &&
            lastResult!.replies.isEmpty == true &&
            replies.isEmpty);

    return RepliesResult(
      replies: replies,
      maxId: result.statuses!.isEmpty ? '0' : result.statuses!.last.idStr,
      lastPage: lastPage,
    );
  }
}

/// Paginated results for replies to a tweet.
class RepliesResult {
  const RepliesResult({
    required this.replies,
    required this.maxId,
    required this.lastPage,
  });

  /// The list of replies to a tweet.
  final List<TweetData> replies;

  /// The id of the last reply.
  final String? maxId;

  /// `true` when we assume that we can't receive more replies.
  final bool lastPage;
}
