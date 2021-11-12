part of 'home_timeline_bloc.dart';

abstract class HomeTimelineEvent {
  const HomeTimelineEvent();

  const factory HomeTimelineEvent.loadInitial() = _LoadInitial;

  const factory HomeTimelineEvent.load({
    bool clearPrevious,
  }) = _Load;

  const factory HomeTimelineEvent.loadOlder() = _LoadOlder;

  const factory HomeTimelineEvent.addTweet({
    required TweetData tweet,
  }) = _AddTweet;

  const factory HomeTimelineEvent.removeTweet({
    required TweetData tweet,
  }) = _RemoveTweet;

  const factory HomeTimelineEvent.applyFilter({
    required TimelineFilter timelineFilter,
  }) = _ApplyFilter;

  Future<void> handle(HomeTimelineBloc bloc, Emitter emit);
}

/// Requests the home timeline tweets that are newer than the newest last
/// visible tweet from the previous session.
///
/// If the last visible tweet is older than the last 200 tweets, it has no
/// affect.
///
/// After successful response, the older tweets are requested using the
/// [HomeTimelineEvent.loadOlder] event.
class _LoadInitial extends HomeTimelineEvent with HarpyLogger {
  const _LoadInitial();

  @override
  Future<void> handle(HomeTimelineBloc bloc, Emitter emit) async {
    final keepTimelinePosition =
        app<GeneralPreferences>().keepLastHomeTimelinePosition;

    final lastVisibleTweet = app<TweetVisibilityPreferences>().lastVisibleTweet;

    log.fine('requesting initial home timeline');
    emit(const HomeTimelineState.loading());

    if (!keepTimelinePosition || lastVisibleTweet == 0) {
      // the user either doesn't want to keep the timeline position or the last
      // visible tweet is not available (first open) -> load normally
      bloc.add(const HomeTimelineEvent.load());
      return;
    }

    String? maxId;

    final tweets = await app<TwitterApi>()
        .timelineService
        .homeTimeline(
          count: 200,
          sinceId: '${lastVisibleTweet - 1}',
          excludeReplies: bloc.filter.excludesReplies,
        )
        .then((tweets) {
          if (tweets.isNotEmpty) {
            maxId = tweets.last.idStr;
          }
          return tweets;
        })
        .then((tweets) => handleTweets(tweets, bloc.filter))
        .handleError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} initial tweets');

      if (tweets.isNotEmpty) {
        emit(
          HomeTimelineState.data(
            tweets: tweets.toBuiltList(),
            maxId: maxId,
            initialResultsLastId: tweets.last.originalId,
            initialResultsCount: tweets.length - 1,
            isInitialResult: true,
          ),
        );

        bloc.add(const HomeTimelineEvent.loadOlder());
      } else {
        // no initial tweets, load normally
        bloc.add(const HomeTimelineEvent.load());
      }
    } else {
      emit(const HomeTimelineState.error());
    }
  }
}

/// Refreshes the home timeline by requesting the newest 200 home timeline
/// tweets.
///
/// If [clearPrevious] is `true`, [HomeTimelineState.loading] is yielded
/// before requesting the timeline to clear the previous tweets and show a
/// loading indicator.
class _Load extends HomeTimelineEvent with HarpyLogger {
  const _Load({
    this.clearPrevious = false,
  });

  final bool clearPrevious;

  @override
  Future<void> handle(HomeTimelineBloc bloc, Emitter emit) async {
    log.fine('refreshing home timeline');

    if (clearPrevious) {
      emit(const HomeTimelineState.loading());
    }

    String? maxId;

    final tweets = await app<TwitterApi>()
        .timelineService
        .homeTimeline(
          count: 200,
          excludeReplies: bloc.filter.excludesReplies,
        )
        .then((tweets) {
          if (tweets.isNotEmpty) {
            maxId = tweets.last.idStr;
          }
          return tweets;
        })
        .then(
          (tweets) => handleTweets(tweets, bloc.filter),
        )
        .handleError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} tweets');

      if (tweets.isNotEmpty) {
        emit(
          HomeTimelineState.data(
            tweets: tweets.toBuiltList(),
            maxId: maxId,
            initialResultsCount: 0,
          ),
        );
      } else {
        emit(const HomeTimelineState.noData());
      }
    } else {
      emit(const HomeTimelineState.error());
    }

    bloc.refreshCompleter.complete();
    bloc.refreshCompleter = Completer<void>();
  }
}

/// An event to request older home timeline tweets.
///
/// This is used when the end of the home timeline has been reached and the
/// user wants to load the older (previous) tweets.
///
/// Only the last 800 tweets in a home timeline can be requested.
class _LoadOlder extends HomeTimelineEvent with HarpyLogger {
  const _LoadOlder();

  String? _findMaxId(_Data state) {
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

    if (state is _Data) {
      final maxId = _findMaxId(state);

      if (maxId == null) {
        log.info('tried to request older but max id was null');
        return;
      }

      log.fine('requesting older home timeline tweets');

      emit(HomeTimelineState.loadingOlder(data: state));

      String? newMaxId;

      final tweets = await app<TwitterApi>()
          .timelineService
          .homeTimeline(
            count: 200,
            maxId: maxId,
            excludeReplies: bloc.filter.excludesReplies,
          )
          .then((tweets) {
            if (tweets.isNotEmpty) {
              newMaxId = tweets.last.idStr;
            }

            return tweets;
          })
          .then((tweets) => handleTweets(tweets, bloc.filter))
          .handleError(twitterApiErrorHandler);

      if (tweets != null) {
        log.fine('found ${tweets.length} older tweets');

        emit(
          state.copyWith(
            tweets: state.tweets.followedBy(tweets).toBuiltList(),
            maxId: newMaxId,
            isInitialResult: false,
          ),
        );
      } else {
        // re-yield result state with previous tweets but new max id
        emit(
          state.copyWith(
            maxId: newMaxId,
            isInitialResult: false,
          ),
        );
      }
    }

    bloc.requestOlderCompleter.complete();
    bloc.requestOlderCompleter = Completer<void>();
  }
}

/// Adds a single [tweet] to the home timeline tweets.
///
/// If the tweet is a reply, the reply will be added to the replies for the
/// parent tweet.
/// Else it will be added to the beginning of the list.
///
/// Only affects the list when the state is [HomeTimelineState.data].
class _AddTweet extends HomeTimelineEvent {
  const _AddTweet({
    required this.tweet,
  });

  final TweetData tweet;

  @override
  Future<void> handle(HomeTimelineBloc bloc, Emitter emit) async {
    final state = bloc.state;

    if (state is _Data) {
      final tweets = List.of(state.tweets);

      if (tweet.parentTweetId == null) {
        tweets.insert(0, tweet);
      }

      emit(
        state.copyWith(
          tweets: tweets.toBuiltList(),
          isInitialResult: false,
        ),
      );
    }
  }
}

/// Removes a single [tweet] from the home timeline tweets.
///
/// Only affects the list when the state is [HomeTimelineState.data].
class _RemoveTweet extends HomeTimelineEvent {
  const _RemoveTweet({
    required this.tweet,
  });

  final TweetData tweet;

  @override
  Future<void> handle(HomeTimelineBloc bloc, Emitter emit) async {
    final state = bloc.state;

    if (state is _Data) {
      final tweets = List.of(state.tweets);

      if (tweet.parentTweetId == null) {
        tweets.removeWhere((element) => element.id == tweet.id);
      }

      emit(
        state.copyWith(
          tweets: tweets.toBuiltList(),
          isInitialResult: false,
        ),
      );
    }
  }
}

/// Sets the filter for the home timeline if the current state is
/// [HomeTimelineState.data] and refreshes the list afterwards.
class _ApplyFilter extends HomeTimelineEvent with HarpyLogger {
  const _ApplyFilter({
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

    bloc.add(const HomeTimelineEvent.load(clearPrevious: true));
  }
}
