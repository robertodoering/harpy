part of 'user_timeline_bloc.dart';

abstract class UserTimelineEvent {
  const UserTimelineEvent();

  Future<void> handle(UserTimelineBloc bloc, Emitter emit);
}

/// Requests the user timeline tweets for the [UserTimelineBloc.screenName].
class RequestUserTimeline extends UserTimelineEvent with HarpyLogger {
  const RequestUserTimeline({
    this.timelineFilter,
  });

  final TimelineFilter? timelineFilter;

  @override
  Future<void> handle(UserTimelineBloc bloc, Emitter emit) async {
    log.fine('requesting user timeline');

    emit(const UserTimelineInitialLoading());

    final filter = timelineFilter ??
        TimelineFilter.fromJsonString(
          app<TimelineFilterPreferences>().userTimelineFilter,
        );

    String? maxId;

    final tweets = await app<TwitterApi>()
        .timelineService
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
        emit(
          UserTimelineResult(
            tweets: tweets,
            timelineFilter: filter,
            maxId: maxId,
          ),
        );
      } else {
        emit(UserTimelineNoResult(timelineFilter: filter));
      }
    } else {
      emit(UserTimelineFailure(timelineFilter: filter));
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

  String? _findMaxId(UserTimelineResult state) {
    final lastId = int.tryParse(state.maxId ?? '');

    if (lastId != null) {
      return '${lastId - 1}';
    } else {
      return null;
    }
  }

  @override
  Future<void> handle(UserTimelineBloc bloc, Emitter emit) async {
    if (bloc.lock()) {
      bloc.requestOlderCompleter.complete();
      bloc.requestOlderCompleter = Completer<void>();
      return;
    }

    final state = bloc.state;

    if (state is UserTimelineResult) {
      final maxId = _findMaxId(state);

      if (maxId == null) {
        log.info('tried to request older but max id was null');
        return;
      }

      log.fine('requesting older user timeline tweets');

      emit(UserTimelineLoadingOlder(oldResult: state));

      String? newMaxId;
      var canRequestOlder = false;

      final tweets = await app<TwitterApi>()
          .timelineService
          .userTimeline(
            screenName: bloc.screenName,
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
          UserTimelineResult(
            tweets: state.tweets.followedBy(tweets).toList(),
            maxId: newMaxId,
            timelineFilter: state.timelineFilter,
            canRequestOlder: canRequestOlder,
          ),
        );
      } else {
        // re-yield result state with previous tweets but new max id
        emit(
          UserTimelineResult(
            tweets: state.tweets,
            maxId: state.maxId,
            timelineFilter: state.timelineFilter,
          ),
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

  void _saveTimelineFilter(UserTimelineBloc bloc) {
    try {
      final encodedFilter = jsonEncode(timelineFilter.toJson());
      log.finer('saving filter: $encodedFilter');

      app<TimelineFilterPreferences>().userTimelineFilter = encodedFilter;
    } catch (e, st) {
      log.warning('unable to encode timeline filter', e, st);
    }
  }

  @override
  Future<void> handle(UserTimelineBloc bloc, Emitter emit) async {
    log.fine('set user timeline filter');

    _saveTimelineFilter(bloc);

    bloc.add(
      RequestUserTimeline(timelineFilter: timelineFilter),
    );
  }
}
