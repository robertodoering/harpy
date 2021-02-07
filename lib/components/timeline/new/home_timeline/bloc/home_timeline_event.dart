part of 'home_timeline_bloc.dart';

abstract class HomeTimelineEvent extends Equatable {
  const HomeTimelineEvent();

  Stream<HomeTimelineState> applyAsync({
    HomeTimelineState currentState,
    NewHomeTimelineBloc bloc,
  });
}

/// Requests the home timeline tweets that are newer than the newest last
/// visible tweet from the previous session.
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
    NewHomeTimelineBloc bloc,
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
          lastInitialTweet: tweets.last.idStr,
          includesLastVisibleTweet: '$lastVisibleTweet' == tweets.last.idStr,
          newTweetsExist: lastVisibleTweet != 0 && tweets.length != 1,
          initialResults: true,
        );

        bloc.add(const RequestOlderHomeTimeline());
      } else {
        yield const HomeTimelineNoResult();
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
    final int lastId = int.tryParse(state.tweets.last.idStr);

    if (lastId != null) {
      return '${lastId - 1}';
    } else {
      return null;
    }
  }

  @override
  Stream<HomeTimelineState> applyAsync({
    HomeTimelineState currentState,
    NewHomeTimelineBloc bloc,
  }) async* {
    final HomeTimelineState state = bloc.state;

    // todo: prevent request spam by blocking continues requests for x seconds

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
          newTweetsExist: state.newTweetsExist,
          canRequestOlder: tweets.isNotEmpty,
        );
      } else {
        // re-yield result state with previous tweets
        yield HomeTimelineResult(
          tweets: state.tweets,
          lastInitialTweet: state.lastInitialTweet,
          includesLastVisibleTweet: state.includesLastVisibleTweet,
          newTweetsExist: state.newTweetsExist,
        );
      }
    }
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
    NewHomeTimelineBloc bloc,
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
          newTweetsExist: false,
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
