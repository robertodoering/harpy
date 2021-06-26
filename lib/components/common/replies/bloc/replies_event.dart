part of 'replies_bloc.dart';

abstract class RepliesEvent {
  const RepliesEvent();

  Stream<RepliesState> applyAsync({
    required RepliesState currentState,
    required RepliesBloc bloc,
  });
}

/// Requests the replies and the parent tweet.
class LoadReplies extends RepliesEvent with HarpyLogger {
  const LoadReplies();

  Future<TweetData?> _loadAllParentTweets(TweetData tweet) async {
    final parent = await _loadParent(tweet);

    if (parent != null) {
      log.fine('loading parent tweets');

      return _loadReplyChain(parent);
    } else {
      log.fine('no parent tweet exist');

      return null;
    }
  }

  Future<List<TweetData>?> _loadReplies(TweetData tweet) async {
    final result = await app<TwitterApi>()
        .tweetSearchService
        .findReplies(tweet)
        .handleError(twitterApiErrorHandler);

    if (result != null) {
      log.fine('found ${result.replies.length} replies');
      return result.replies;
    } else {
      return null;
    }
  }

  @override
  Stream<RepliesState> applyAsync({
    required RepliesState currentState,
    required RepliesBloc bloc,
  }) async* {
    log.fine('loading replies for ${bloc.tweet.id}');

    yield const LoadingReplies();

    final results = await Future.wait<dynamic>([
      _loadAllParentTweets(bloc.tweet),
      _loadReplies(bloc.tweet),
    ]);

    final TweetData? parent = results[0] is TweetData ? results[0] : null;
    final List<TweetData>? replies =
        results[1] is List<TweetData> ? results[1] : null;

    if (replies != null) {
      if (replies.isNotEmpty) {
        log.fine('found ${replies.length} replies');

        yield RepliesResult(replies: replies, parent: parent);
      } else {
        log.fine('no replies found');

        yield RepliesNoResult(parent: parent);
      }
    } else {
      log.fine('error requesting replies');

      yield RepliesFailure(parent: parent);
    }
  }
}

/// Loads the parent of a single [tweet] if one exist.
Future<TweetData?> _loadParent(TweetData tweet) async {
  if (tweet.hasParent) {
    final parent = await app<TwitterApi>()
        .tweetService
        .show(id: tweet.parentTweetId!)
        .then((tweet) => TweetData.fromTweet(tweet))
        .handleError(silentErrorHandler);

    return parent;
  } else {
    return null;
  }
}

/// Loads all parents recursively and adds them as their [TweetData.replies].
Future<TweetData> _loadReplyChain(TweetData tweet) async {
  final parent = await _loadParent(tweet);

  if (parent != null) {
    return _loadReplyChain(parent..replies = [tweet]);
  } else {
    return tweet;
  }
}
