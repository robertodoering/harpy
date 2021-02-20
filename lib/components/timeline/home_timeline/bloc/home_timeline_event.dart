part of 'home_timeline_bloc.dart';

abstract class HomeTimelineEvent extends Equatable {
  const HomeTimelineEvent();

  Stream<HomeTimelineState> applyAsync({
    HomeTimelineState currentState,
    HomeTimelineBloc bloc,
  });
}

/// Requests the home timeline tweets that are newer than the newest last
/// visible tweet from the previous session.
///
/// If the last visible tweet is older than the last 200 tweets, it has no
/// affect.
///
/// After successful response, the older tweets are requested using the
/// [RequestOlderHomeTimeline] event.
class RequestInitialHomeTimeline extends HomeTimelineEvent with Logger {
  const RequestInitialHomeTimeline();

  @override
  List<Object> get props => <Object>[];

  String _sinceId(int lastVisibleTweet) {
    if (lastVisibleTweet != 0) {
      return '${lastVisibleTweet - 1}';
    } else {
      return null;
    }
  }

  @override
  Stream<HomeTimelineState> applyAsync({
    HomeTimelineState currentState,
    HomeTimelineBloc bloc,
  }) async* {
    log.fine('requesting initial home timeline');

    yield const HomeTimelineInitialLoading();

    final int lastVisibleTweet =
        bloc.tweetVisibilityPreferences.lastVisibleTweet;

    final List<TweetData> tweets = await bloc.timelineService
        .homeTimeline(
          count: 200,
          sinceId: _sinceId(lastVisibleTweet),
        )
        .then(handleTweets)
        .catchError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} initial tweets');

      if (tweets.isNotEmpty) {
        yield HomeTimelineResult(
          tweets: tweets,
          lastInitialTweet: tweets.last.originalIdStr,
          includesLastVisibleTweet:
              '$lastVisibleTweet' == tweets.last.originalIdStr,
          newTweets: lastVisibleTweet == 0 ? 0 : tweets.length - 1,
          initialResults: true,
        );

        bloc.add(const RequestOlderHomeTimeline());
      } else {
        bloc.add(const RefreshHomeTimeline());
      }
    } else {
      yield const HomeTimelineFailure();
    }
  }
}

/// An event to request older home timeline tweets.
///
/// This is used when the end of the home timeline has been reached and the
/// user wants to load the older (previous) tweets.
///
/// Only the last 800 tweets in a home timeline can be requested.
class RequestOlderHomeTimeline extends HomeTimelineEvent with Logger {
  const RequestOlderHomeTimeline();

  @override
  List<Object> get props => <Object>[];

  String _findMaxId(HomeTimelineResult state) {
    final int lastId = int.tryParse(state.tweets.last.originalIdStr);

    if (lastId != null) {
      return '${lastId - 1}';
    } else {
      return null;
    }
  }

  @override
  Stream<HomeTimelineState> applyAsync({
    HomeTimelineState currentState,
    HomeTimelineBloc bloc,
  }) async* {
    if (bloc.lock()) {
      return;
    }

    final HomeTimelineState state = bloc.state;

    if (state is HomeTimelineResult) {
      final String maxId = _findMaxId(state);

      if (maxId == null) {
        return;
      }

      log.fine('requesting older home timeline tweets');

      yield HomeTimelineLoadingOlder(oldResult: state);

      final List<TweetData> tweets = await bloc.timelineService
          .homeTimeline(
            count: 200,
            maxId: maxId,
          )
          .then(handleTweets)
          .catchError(twitterApiErrorHandler);

      if (tweets != null) {
        log.fine('found ${tweets.length} older tweets');

        yield HomeTimelineResult(
          tweets: state.tweets.followedBy(tweets).toList(),
          lastInitialTweet: state.lastInitialTweet,
          includesLastVisibleTweet: state.includesLastVisibleTweet,
          newTweets: state.newTweets,
          canRequestOlder: tweets.isNotEmpty,
        );
      } else {
        // re-yield result state with previous tweets
        yield HomeTimelineResult(
          tweets: state.tweets,
          lastInitialTweet: state.lastInitialTweet,
          includesLastVisibleTweet: state.includesLastVisibleTweet,
          newTweets: state.newTweets,
        );
      }
    }

    bloc.requestOlderCompleter.complete();
    bloc.requestOlderCompleter = Completer<void>();
  }
}

/// Refreshes the home timeline by requesting the newest 200 home timeline
/// tweets.
///
/// If [clearPrevious] is `true`, [HomeTimelineInitialLoading] is yielded
/// before requesting the timeline to clear the previous tweets and show a
/// loading indicator.
class RefreshHomeTimeline extends HomeTimelineEvent with Logger {
  const RefreshHomeTimeline({
    this.clearPrevious = false,
  });

  final bool clearPrevious;

  @override
  List<Object> get props => <Object>[
        clearPrevious,
      ];

  @override
  Stream<HomeTimelineState> applyAsync({
    HomeTimelineState currentState,
    HomeTimelineBloc bloc,
  }) async* {
    log.fine('refreshing home timeline');

    if (clearPrevious) {
      yield const HomeTimelineInitialLoading();
    }

    final List<TweetData> tweets = await bloc.timelineService
        .homeTimeline(
          count: 200,
        )
        .then(handleTweets)
        .catchError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} tweets');

      if (tweets.isNotEmpty) {
        yield HomeTimelineResult(
          tweets: tweets,
          includesLastVisibleTweet: false,
          newTweets: 0,
        );
      } else {
        yield const HomeTimelineNoResult();
      }
    } else {
      yield const HomeTimelineFailure();
    }

    bloc.refreshCompleter.complete();
    bloc.refreshCompleter = Completer<void>();
  }
}

/// Adds a single [tweet] to the home timeline tweets.
///
/// If the tweet is a reply, the reply will be added to the replies for the
/// parent tweet.
/// Else it will be added to the beginning of the list.
///
/// Only affects the list when the state is [HomeTimelineResult].
class AddToHomeTimeline extends HomeTimelineEvent {
  const AddToHomeTimeline({
    @required this.tweet,
  });

  final TweetData tweet;

  @override
  List<Object> get props => <Object>[
        tweet,
      ];

  bool _addToParent(List<TweetData> tweets) {
    final TweetData parent = tweets.firstWhere(
      (TweetData element) => element.idStr == tweet.inReplyToStatusIdStr,
      orElse: () => null,
    );

    if (parent != null) {
      parent.replies.add(tweet);
      return true;
    } else {
      return false;
    }
  }

  @override
  Stream<HomeTimelineState> applyAsync({
    HomeTimelineState currentState,
    HomeTimelineBloc bloc,
  }) async* {
    if (currentState is HomeTimelineResult) {
      final List<TweetData> tweets = List<TweetData>.of(currentState.tweets);

      if (tweet.inReplyToStatusIdStr == null || !_addToParent(tweets)) {
        tweets.insert(0, tweet);
      }

      yield HomeTimelineResult(
        tweets: tweets,
        includesLastVisibleTweet: currentState.includesLastVisibleTweet,
        newTweets: currentState.newTweets,
        lastInitialTweet: currentState.lastInitialTweet,
        initialResults: currentState.initialResults,
        canRequestOlder: currentState.canRequestOlder,
      );
    }
  }
}

/// Removes a single [tweet] from the home timeline tweets.
///
/// Only affects the list when the state is [HomeTimelineResult].
class RemoveFromHomeTimeline extends HomeTimelineEvent {
  const RemoveFromHomeTimeline({
    @required this.tweet,
  });

  final TweetData tweet;

  @override
  List<Object> get props => <Object>[
        tweet,
      ];

  bool _removeChild(List<TweetData> tweets) {
    final TweetData parent = tweets.firstWhere(
      (TweetData element) => element.idStr == tweet.inReplyToStatusIdStr,
      orElse: () => null,
    );

    if (parent != null) {
      parent.replies.removeWhere(
        (TweetData element) => element.idStr == tweet.idStr,
      );
      return true;
    } else {
      return false;
    }
  }

  @override
  Stream<HomeTimelineState> applyAsync({
    HomeTimelineState currentState,
    HomeTimelineBloc bloc,
  }) async* {
    if (currentState is HomeTimelineResult) {
      final List<TweetData> tweets = List<TweetData>.of(currentState.tweets);

      if (tweet.inReplyToStatusIdStr == null || !_removeChild(tweets)) {
        tweets.removeWhere((TweetData element) => element.idStr == tweet.idStr);
      }

      yield HomeTimelineResult(
        tweets: tweets,
        includesLastVisibleTweet: currentState.includesLastVisibleTweet,
        newTweets: currentState.newTweets,
        lastInitialTweet: currentState.lastInitialTweet,
        initialResults: currentState.initialResults,
        canRequestOlder: currentState.canRequestOlder,
      );
    }
  }
}
