part of 'home_timeline_bloc.dart';

abstract class HomeTimelineEvent {
  const HomeTimelineEvent();

  Future<void> handle(HomeTimelineBloc bloc, Emitter emit);
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

  String? _sinceId(int lastVisibleTweet, bool keepTimelinePosition) {
    if (keepTimelinePosition && lastVisibleTweet != 0) {
      return '${lastVisibleTweet - 1}';
    } else {
      return null;
    }
  }

  @override
  Future<void> handle(HomeTimelineBloc bloc, Emitter emit) async {
    log.fine('requesting initial home timeline');

    emit(const HomeTimelineInitialLoading());

    final filter = TimelineFilter.fromJsonString(
      app<TimelineFilterPreferences>().homeTimelineFilter,
    );

    final lastVisibleTweet = app<TweetVisibilityPreferences>().lastVisibleTweet;
    final keepTimelinePosition =
        app<GeneralPreferences>().keepLastHomeTimelinePosition;

    String? maxId;

    final tweets = await app<TwitterApi>()
        .timelineService
        .homeTimeline(
          count: 200,
          sinceId: _sinceId(lastVisibleTweet, keepTimelinePosition),
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
        emit(
          HomeTimelineResult(
            tweets: tweets,
            maxId: maxId,
            timelineFilter: filter,
            lastInitialTweet: tweets.last.originalId,
            newTweets: keepTimelinePosition && lastVisibleTweet != 0
                ? tweets.length - 1
                : 0,
            initialResults: true,
          ),
        );

        if (keepTimelinePosition) {
          bloc.add(const RequestOlderHomeTimeline());
        }
      } else {
        bloc.add(RefreshHomeTimeline(timelineFilter: filter));
      }
    } else {
      emit(HomeTimelineFailure(timelineFilter: filter));
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

  String? _findMaxId(HomeTimelineResult state) {
    final lastId = int.tryParse(state.maxId ?? '');

    if (lastId != null) {
      return '${lastId - 1}';
    } else {
      return null;
    }
  }

  @override
  Future<void> handle(HomeTimelineBloc bloc, Emitter emit) async {
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

      emit(HomeTimelineLoadingOlder(oldResult: state));

      String? newMaxId;
      var canRequestOlder = false;

      final tweets = await app<TwitterApi>()
          .timelineService
          .homeTimeline(
            count: 200,
            maxId: maxId,
            excludeReplies: state.timelineFilter.excludesReplies,
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
          .then((tweets) => handleTweets(tweets, state.timelineFilter))
          .handleError(twitterApiErrorHandler);

      if (tweets != null) {
        log
          ..fine('found ${tweets.length} older tweets')
          ..finer('can request older: $canRequestOlder');

        emit(
          HomeTimelineResult(
            tweets: state.tweets.followedBy(tweets).toList(),
            maxId: newMaxId,
            timelineFilter: state.timelineFilter,
            lastInitialTweet: state.lastInitialTweet,
            newTweets: state.newTweets,
            canRequestOlder: canRequestOlder,
          ),
        );
      } else {
        // re-yield result state with previous tweets but new max id
        emit(
          HomeTimelineResult(
            tweets: state.tweets,
            maxId: newMaxId,
            timelineFilter: state.timelineFilter,
            lastInitialTweet: state.lastInitialTweet,
            newTweets: state.newTweets,
          ),
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
  Future<void> handle(HomeTimelineBloc bloc, Emitter emit) async {
    log.fine('refreshing home timeline');

    if (clearPrevious) {
      emit(const HomeTimelineInitialLoading());
    }

    String? maxId;

    final tweets = await app<TwitterApi>()
        .timelineService
        .homeTimeline(
          count: 200,
          excludeReplies: timelineFilter?.excludesReplies ??
              bloc.state.timelineFilter.excludesReplies,
        )
        .then((tweets) {
          if (tweets.isNotEmpty) {
            maxId = tweets.last.idStr;
          }
          return tweets;
        })
        .then(
          (tweets) => handleTweets(
            tweets,
            timelineFilter ?? bloc.state.timelineFilter,
          ),
        )
        .handleError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} tweets');

      if (tweets.isNotEmpty) {
        emit(
          HomeTimelineResult(
            tweets: tweets,
            maxId: maxId,
            timelineFilter: timelineFilter ?? bloc.state.timelineFilter,
            newTweets: 0,
          ),
        );
      } else {
        emit(
          HomeTimelineNoResult(
            timelineFilter: timelineFilter ?? bloc.state.timelineFilter,
          ),
        );
      }
    } else {
      emit(
        HomeTimelineFailure(
          timelineFilter: timelineFilter ?? bloc.state.timelineFilter,
        ),
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
  Future<void> handle(HomeTimelineBloc bloc, Emitter emit) async {
    final state = bloc.state;

    if (state is HomeTimelineResult) {
      final tweets = List.of(state.tweets);

      if (tweet.parentTweetId == null) {
        tweets.insert(0, tweet);
      }

      emit(
        HomeTimelineResult(
          tweets: tweets,
          maxId: state.maxId,
          timelineFilter: state.timelineFilter,
          newTweets: state.newTweets,
          lastInitialTweet: state.lastInitialTweet,
          initialResults: state.initialResults,
          canRequestOlder: state.canRequestOlder,
        ),
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
  Future<void> handle(HomeTimelineBloc bloc, Emitter emit) async {
    final state = bloc.state;

    if (state is HomeTimelineResult) {
      final tweets = List.of(state.tweets);

      if (tweet.parentTweetId == null) {
        tweets.removeWhere((element) => element.id == tweet.id);
      }

      emit(
        HomeTimelineResult(
          tweets: tweets,
          maxId: state.maxId,
          timelineFilter: state.timelineFilter,
          newTweets: state.newTweets,
          lastInitialTweet: state.lastInitialTweet,
          initialResults: state.initialResults,
          canRequestOlder: state.canRequestOlder,
        ),
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

  void _saveTimelineFilter(HomeTimelineBloc bloc) {
    try {
      final encodedFilter = jsonEncode(timelineFilter.toJson());
      log.finer('saving filter: $encodedFilter');

      app<TimelineFilterPreferences>().homeTimelineFilter = encodedFilter;
    } catch (e, st) {
      log.warning('unable to encode timeline filter', e, st);
    }
  }

  @override
  Future<void> handle(HomeTimelineBloc bloc, Emitter emit) async {
    log.fine('set home timeline filter');

    _saveTimelineFilter(bloc);

    bloc.add(
      RefreshHomeTimeline(
        clearPrevious: true,
        timelineFilter: timelineFilter,
      ),
    );
  }
}
