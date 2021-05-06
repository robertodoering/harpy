part of 'user_timeline_bloc.dart';

abstract class UserTimelineEvent extends Equatable {
  const UserTimelineEvent();

  Stream<UserTimelineState> applyAsync({
    required UserTimelineState currentState,
    required UserTimelineBloc bloc,
  });
}

/// Requests the user timeline tweets for the [UserTimelineBloc.screenName].
class RequestUserTimeline extends UserTimelineEvent with HarpyLogger {
  const RequestUserTimeline({
    this.timelineFilter,
  });

  final TimelineFilter? timelineFilter;

  @override
  List<Object?> get props => <Object?>[
        timelineFilter,
      ];

  @override
  Stream<UserTimelineState> applyAsync({
    required UserTimelineState currentState,
    required UserTimelineBloc bloc,
  }) async* {
    log.fine('requesting user timeline');

    yield const UserTimelineInitialLoading();

    final filter = timelineFilter ??
        TimelineFilter.fromJsonString(
          bloc.timelineFilterPreferences!.userTimelineFilter,
        );

    String? maxId;

    final tweets = await bloc.timelineService
        .userTimeline(
          screenName: bloc.screenName,
          count: 200,
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
        yield UserTimelineResult(
          tweets: tweets,
          timelineFilter: filter,
          maxId: maxId,
        );
      } else {
        yield UserTimelineNoResult(timelineFilter: filter);
      }
    } else {
      yield UserTimelineFailure(timelineFilter: filter);
    }

    bloc.requestTimelineCompleter.complete();
    bloc.requestTimelineCompleter = Completer<void>();
  }
}

/// An event to request older user timeline tweets.
///
/// This is used when the end of the user timeline has been reached and the
/// user wants to load the older (previous) tweets.
///
/// Only the last 800 tweets in a user timeline can be requested.
class RequestOlderUserTimeline extends UserTimelineEvent with HarpyLogger {
  const RequestOlderUserTimeline();

  @override
  List<Object> get props => <Object>[];

  String? _findMaxId(UserTimelineResult state) {
    final lastId = int.tryParse(state.maxId ?? '');

    if (lastId != null) {
      return '${lastId - 1}';
    } else {
      return null;
    }
  }

  @override
  Stream<UserTimelineState> applyAsync({
    required UserTimelineState currentState,
    required UserTimelineBloc bloc,
  }) async* {
    if (bloc.lock()) {
      bloc.requestOlderCompleter.complete();
      bloc.requestOlderCompleter = Completer<void>();
      return;
    }

    if (currentState is UserTimelineResult) {
      final maxId = _findMaxId(currentState);

      if (maxId == null) {
        log.info('tried to request older but max id was null');
        return;
      }

      log.fine('requesting older user timeline tweets');

      yield UserTimelineLoadingOlder(oldResult: currentState);

      String? newMaxId;
      var canRequestOlder = false;

      final tweets = await bloc.timelineService
          .userTimeline(
            screenName: bloc.screenName,
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

        yield UserTimelineResult(
          tweets: currentState.tweets.followedBy(tweets).toList(),
          maxId: newMaxId,
          timelineFilter: currentState.timelineFilter,
          canRequestOlder: canRequestOlder,
        );
      } else {
        // re-yield result state with previous tweets but new max id
        yield UserTimelineResult(
          tweets: currentState.tweets,
          maxId: currentState.maxId,
          timelineFilter: currentState.timelineFilter,
        );
      }
    }

    bloc.requestOlderCompleter.complete();
    bloc.requestOlderCompleter = Completer<void>();
  }
}

/// Sets the filter for the user timeline if the current state is
/// [UserTimelineResult] and refreshes the list afterwards.
class FilterUserTimeline extends UserTimelineEvent with HarpyLogger {
  const FilterUserTimeline({
    required this.timelineFilter,
  });

  final TimelineFilter timelineFilter;

  @override
  List<Object> get props => <Object>[
        timelineFilter,
      ];

  void _saveTimelineFilter(UserTimelineBloc bloc) {
    try {
      final encodedFilter = jsonEncode(timelineFilter.toJson());
      log.finer('saving filter: $encodedFilter');

      bloc.timelineFilterPreferences!.userTimelineFilter = encodedFilter;
    } catch (e, st) {
      log.warning('unable to encode timeline filter', e, st);
    }
  }

  @override
  Stream<UserTimelineState> applyAsync({
    required UserTimelineState currentState,
    required UserTimelineBloc bloc,
  }) async* {
    log.fine('set user timeline filter');

    _saveTimelineFilter(bloc);

    bloc.add(RequestUserTimeline(
      timelineFilter: timelineFilter,
    ));
  }
}
