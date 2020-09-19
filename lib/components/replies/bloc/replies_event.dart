import 'package:dart_twitter_api/api/tweets/tweet_search_service.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/replies/bloc/replies_bloc.dart';
import 'package:harpy/components/replies/bloc/replies_state.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:logging/logging.dart';

@immutable
abstract class RepliesEvent {
  const RepliesEvent();

  static final Logger _log = Logger('RepliesEvent');

  Future<void> _loadReplies(RepliesBloc bloc) async {
    final RepliesResult result = await bloc.searchService
        .findReplies(bloc.originalTweet, bloc.lastResult)
        .catchError(twitterApiErrorHandler);

    if (result != null) {
      bloc.lastResult = result;

      result.replies.sort((TweetData a, TweetData b) {
        return b.favoriteCount - a.favoriteCount;
      });

      bloc.replies.addAll(result.replies);
      _log.fine('found ${result.replies.length} replies');
    }
  }

  Stream<RepliesState> applyAsync({
    RepliesState currentState,
    RepliesBloc bloc,
  });
}

/// Loads the replies for the [RepliesBloc.tweet].
///
/// If the [RepliesBloc.tweet] itself is a reply, the parent tweets will also be
/// loaded.
class LoadRepliesEvent extends RepliesEvent {
  const LoadRepliesEvent();

  static final Logger _log = Logger('LoadRepliesEvent');

  Future<TweetData> _loadParentTweets(
    RepliesBloc bloc,
    TweetData tweet,
  ) async {
    if (tweet.hasParent) {
      final TweetData parent = await bloc.tweetService
          .show(id: tweet.inReplyToStatusIdStr)
          .then((Tweet tweet) => TweetData.fromTweet(tweet))
          .catchError(silentErrorHandler);

      if (parent != null) {
        parent.replies.add(tweet);
        return _loadParentTweets(bloc, parent);
      }
    }

    _log.fine('found ${tweet.replies.length} parent tweets');

    return tweet;
  }

  @override
  Stream<RepliesState> applyAsync({
    RepliesState currentState,
    RepliesBloc bloc,
  }) async* {
    yield LoadingParentsState();

    bloc.tweet = await _loadParentTweets(bloc, bloc.originalTweet);

    yield LoadingRepliesState();

    await _loadReplies(bloc);

    if (bloc.replies.isEmpty && !bloc.lastResult.lastPage) {
      // try loading next page if first result did not yield any replies for
      // the tweet
      await _loadReplies(bloc);
    }

    yield LoadedRepliesState();
  }
}

/// Loads the next replies when more replies for the [RepliesBloc.tweet] exist.
class LoadMoreRepliesEvent extends RepliesEvent {
  const LoadMoreRepliesEvent();

  static final Logger _log = Logger('LoadMoreRepliesEvent');

  @override
  Stream<RepliesState> applyAsync({
    RepliesState currentState,
    RepliesBloc bloc,
  }) async* {
    if (bloc.allRepliesLoaded) {
      _log.fine('all replies already loaded');
      return;
    }

    await _loadReplies(bloc);

    yield LoadedRepliesState();
  }
}

extension on TweetSearchService {
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
  Future<RepliesResult> findReplies(
    TweetData tweet,
    RepliesResult lastResult,
  ) async {
    final String screenName = tweet.userData.screenName;

    final String maxId =
        lastResult == null ? null : '${int.tryParse(lastResult.maxId) + 1}';

    final TweetSearch result = await searchTweets(
      q: 'to:$screenName',
      sinceId: tweet.idStr,
      count: 100,
      maxId: maxId,
    );

    final List<TweetData> replies = <TweetData>[];

    // filter found tweets by replies
    for (Tweet reply in result.statuses) {
      if (reply.inReplyToStatusIdStr == tweet.idStr) {
        replies.add(TweetData.fromTweet(reply));
      }
    }

    // expect no more replies exists if no replies in the last 2 requests have
    // been found
    final bool lastPage = result.statuses.length < 100 ||
        (lastResult?.replies?.isEmpty == true && replies.isEmpty);

    return RepliesResult(
      replies: replies,
      maxId: result.statuses.isEmpty ? '0' : result.statuses.last.idStr,
      lastPage: lastPage,
    );
  }
}

/// Paginated results for replies to a tweet.
class RepliesResult {
  const RepliesResult({
    @required this.replies,
    @required this.maxId,
    @required this.lastPage,
  });

  /// The list of replies to a tweet.
  final List<TweetData> replies;

  /// The id of the last reply.
  final String maxId;

  /// `true` when we assume that we can't receive more replies.
  final bool lastPage;
}
