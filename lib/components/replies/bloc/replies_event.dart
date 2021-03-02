import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/replies/api/find_tweet_replies.dart';
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

    if (bloc.replies.isEmpty &&
        bloc.lastResult != null &&
        !bloc.lastResult.lastPage) {
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
