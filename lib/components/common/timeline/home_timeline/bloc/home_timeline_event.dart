part of 'home_timeline_bloc.dart';

abstract class HomeTimelineEvent extends Equatable {
  const HomeTimelineEvent();

  Stream<HomeTimelineState> applyAsync({
    required HomeTimelineState currentState,
    required HomeTimelineBloc bloc,
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
class RequestInitialHomeTimeline extends HomeTimelineEvent with HarpyLogger {
  const RequestInitialHomeTimeline();

  @override
  List<Object> get props => <Object>[];

  String? _sinceId(int lastVisibleTweet) {
    if (lastVisibleTweet != 0) {
      return '${lastVisibleTweet - 1}';
    } else {
      return null;
    }
  }

  @override
  Stream<HomeTimelineState> applyAsync({
    required HomeTimelineState currentState,
    required HomeTimelineBloc bloc,
  }) async* {
    log.fine('requesting initial home timeline');

    yield const HomeTimelineInitialLoading();

    final filter = TimelineFilter.fromJsonString(
      bloc.timelineFilterPreferences.homeTimelineFilter,
    );

    final lastVisibleTweet = bloc.tweetVisibilityPreferences.lastVisibleTweet;

    String? maxId;

    final tweets = await bloc.timelineService
        .homeTimeline(
          count: 200,
          sinceId: _sinceId(lastVisibleTweet),
          excludeReplies: filter.excludesReplies,
        )
        .then((tweets) {
          if (tweets.isNotEmpty) {
            maxId = tweets.last.idStr;
          }
          return tweets;
        })
        .then((tweets) => handleTweets(tweets, filter))
        .handleError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} initial tweets');

      if (tweets.isNotEmpty) {
        yield HomeTimelineResult(
          tweets: tweets,
          maxId: maxId,
          timelineFilter: filter,
          lastInitialTweet: tweets.last.originalId,
          newTweets: lastVisibleTweet == 0 ? 0 : tweets.length - 1,
          initialResults: true,
        );

        bloc.add(const RequestOlderHomeTimeline());
      } else {
        bloc.add(RefreshHomeTimeline(timelineFilter: filter));
      }
    } else {
      yield HomeTimelineFailure(timelineFilter: filter);
    }
  }
}

/// An event to request older home timeline tweets.
///
/// This is used when the end of the home timeline has been reached and the
/// user wants to load the older (previous) tweets.
///
/// Only the last 800 tweets in a home timeline can be requested.
class RequestOlderHomeTimeline extends HomeTimelineEvent with HarpyLogger {
  const RequestOlderHomeTimeline();

  @override
  List<Object> get props => <Object>[];

  String? _findMaxId(HomeTimelineResult state) {
    final lastId = int.tryParse(state.maxId ?? '');

    if (lastId != null) {
      return '${lastId - 1}';
    } else {
      return null;
    }
  }

  @override
  Stream<HomeTimelineState> applyAsync({
    required HomeTimelineState currentState,
    required HomeTimelineBloc bloc,
  }) async* {
    if (bloc.lock()) {
      bloc.requestOlderCompleter.complete();
      bloc.requestOlderCompleter = Completer<void>();
      return;
    }

    final state = bloc.state;

    if (state is HomeTimelineResult) {
      final maxId = _findMaxId(state);

      if (maxId == null) {
        log.info('tried to request older but max id was null');
        return;
      }

      log.fine('requesting older home timeline tweets');

      yield HomeTimelineLoadingOlder(oldResult: state);

      String? newMaxId;
      var canRequestOlder = false;

      final tweets = await bloc.timelineService
          .homeTimeline(
            count: 200,
            maxId: maxId,
            excludeReplies: currentState.timelineFilter.excludesReplies,
          )
          .then((tweets) {
            if (tweets.isNotEmpty) {
              newMaxId = tweets.last.idStr;
              canRequestOlder = true;
            } else {
              canRequestOlder = false;
            }
            return tweets;
          })
          .then((tweets) => handleTweets(tweets, currentState.timelineFilter))
          .handleError(twitterApiErrorHandler);

      if (tweets != null) {
        log.fine('found ${tweets.length} older tweets');
        log.finer('can request older: $canRequestOlder');

        yield HomeTimelineResult(
          tweets: state.tweets.followedBy(tweets).toList(),
          maxId: newMaxId,
          timelineFilter: currentState.timelineFilter,
          lastInitialTweet: state.lastInitialTweet,
          newTweets: state.newTweets,
          canRequestOlder: canRequestOlder,
        );
      } else {
        // re-yield result state with previous tweets but new max id
        yield HomeTimelineResult(
          tweets: state.tweets,
          maxId: newMaxId,
          timelineFilter: currentState.timelineFilter,
          lastInitialTweet: state.lastInitialTweet,
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
class RefreshHomeTimeline extends HomeTimelineEvent with HarpyLogger {
  const RefreshHomeTimeline({
    this.clearPrevious = false,
    this.timelineFilter,
  });

  final bool clearPrevious;
  final TimelineFilter? timelineFilter;

  @override
  List<Object?> get props => <Object?>[
        clearPrevious,
        timelineFilter,
      ];

  @override
  Stream<HomeTimelineState> applyAsync({
    required HomeTimelineState currentState,
    required HomeTimelineBloc bloc,
  }) async* {
    log.fine('refreshing home timeline');

    if (clearPrevious) {
      yield const HomeTimelineInitialLoading();
    }

    String? maxId;

    final tweets = await bloc.timelineService
        .homeTimeline(
          count: 200,
          excludeReplies: timelineFilter?.excludesReplies ??
              currentState.timelineFilter.excludesReplies,
        )
        .then((tweets) {
          if (tweets.isNotEmpty) {
            maxId = tweets.last.idStr;
          }
          return tweets;
        })
        .then((tweets) =>
            handleTweets(tweets, timelineFilter ?? currentState.timelineFilter))
        .handleError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} tweets');

      if (tweets.isNotEmpty) {
        yield HomeTimelineResult(
          tweets: tweets,
          maxId: maxId,
          timelineFilter: timelineFilter ?? currentState.timelineFilter,
          newTweets: 0,
        );
      } else {
        yield HomeTimelineNoResult(
          timelineFilter: timelineFilter ?? currentState.timelineFilter,
        );
      }
    } else {
      yield HomeTimelineFailure(
        timelineFilter: timelineFilter ?? currentState.timelineFilter,
      );
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
    required this.tweet,
  });

  final TweetData tweet;

  @override
  List<Object> get props => <Object>[
        tweet,
      ];

  @override
  Stream<HomeTimelineState> applyAsync({
    HomeTimelineState? currentState,
    HomeTimelineBloc? bloc,
  }) async* {
    if (currentState is HomeTimelineResult) {
      final tweets = List<TweetData>.of(currentState.tweets);

      if (tweet.parentTweetId == null) {
        tweets.insert(0, tweet);
      }

      yield HomeTimelineResult(
        tweets: tweets,
        maxId: currentState.maxId,
        timelineFilter: currentState.timelineFilter,
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
    required this.tweet,
  });

  final TweetData tweet;

  @override
  List<Object?> get props => <Object?>[
        tweet,
      ];

  @override
  Stream<HomeTimelineState> applyAsync({
    HomeTimelineState? currentState,
    HomeTimelineBloc? bloc,
  }) async* {
    if (currentState is HomeTimelineResult) {
      final tweets = List<TweetData>.of(currentState.tweets);

      if (tweet.parentTweetId == null) {
        tweets.removeWhere((element) => element.id == tweet.id);
      }

      yield HomeTimelineResult(
        tweets: tweets,
        maxId: currentState.maxId,
        timelineFilter: currentState.timelineFilter,
        newTweets: currentState.newTweets,
        lastInitialTweet: currentState.lastInitialTweet,
        initialResults: currentState.initialResults,
        canRequestOlder: currentState.canRequestOlder,
      );
    }
  }
}

/// Sets the filter for the home timeline if the current state is
/// [HomeTimelineResult] and refreshes the list afterwards.
class FilterHomeTimeline extends HomeTimelineEvent with HarpyLogger {
  const FilterHomeTimeline({
    required this.timelineFilter,
  });

  final TimelineFilter timelineFilter;

  @override
  List<Object> get props => <Object>[
        timelineFilter,
      ];

  void _saveTimelineFilter(HomeTimelineBloc bloc) {
    try {
      final encodedFilter = jsonEncode(timelineFilter.toJson());
      log.finer('saving filter: $encodedFilter');

      bloc.timelineFilterPreferences.homeTimelineFilter = encodedFilter;
    } catch (e, st) {
      log.warning('unable to encode timeline filter', e, st);
    }
  }

  @override
  Stream<HomeTimelineState> applyAsync({
    HomeTimelineState? currentState,
    HomeTimelineBloc? bloc,
  }) async* {
    log.fine('set home timeline filter');

    _saveTimelineFilter(bloc!);

    bloc.add(RefreshHomeTimeline(
      clearPrevious: true,
      timelineFilter: timelineFilter,
    ));
  }
}
