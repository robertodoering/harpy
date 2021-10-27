part of 'list_timeline_bloc.dart';

abstract class ListTimelineEvent {
  const ListTimelineEvent();

  Future<void> handle(ListTimelineBloc bloc, Emitter emit);
}

/// Requests the newest 200 tweets for a list.
class RequestListTimeline extends ListTimelineEvent with HarpyLogger {
  const RequestListTimeline();

  @override
  Future<void> handle(ListTimelineBloc bloc, Emitter emit) async {
    log.fine('requesting list timeline');

    emit(const ListTimelineLoading());

    final tweets = await app<TwitterApi>()
        .listsService
        .statuses(listId: bloc.listId, count: 200)
        .then(handleTweets)
        .handleError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} list tweets');

      if (tweets.isNotEmpty) {
        emit(
          ListTimelineResult(
            tweets: tweets,
            maxId: tweets.last.id,
          ),
        );
      } else {
        emit(const ListTimelineNoResult());
      }
    } else {
      emit(const ListTimelineFailure());
    }
  }
}

/// An event to request older list timeline tweets.
///
/// This is used when the end of the list timeline has been reached and the
/// user wants to load the older (previous) tweets.
class RequestOlderListTimeline extends ListTimelineEvent with HarpyLogger {
  const RequestOlderListTimeline();

  String? _findMaxId(ListTimelineResult state) {
    final lastId = int.tryParse(state.maxId ?? '');

    return lastId != null ? '${lastId - 1}' : null;
  }

  @override
  Future<void> handle(ListTimelineBloc bloc, Emitter emit) async {
    if (bloc.lock()) {
      bloc.requestOlderCompleter.complete();
      bloc.requestOlderCompleter = Completer<void>();
      return;
    }

    final state = bloc.state;

    if (state is ListTimelineResult) {
      final maxId = _findMaxId(state);

      if (maxId == null) {
        log.info('tried to request older but max id was null');
        return;
      }

      log.fine('requesting older list timeline');

      emit(ListTimelineLoadingOlder(oldResult: state));

      final tweets = await app<TwitterApi>()
          .listsService
          .statuses(listId: bloc.listId, count: 200, maxId: maxId)
          .then(handleTweets)
          .handleError(twitterApiErrorHandler);

      if (tweets != null) {
        log.fine('found ${tweets.length} older list tweets');

        emit(
          ListTimelineResult(
            tweets: state.tweets.followedBy(tweets).toList(),
            maxId: tweets.last.id,
            canRequestOlder: tweets.isNotEmpty,
          ),
        );
      } else {
        emit(
          ListTimelineResult(
            tweets: state.tweets,
            maxId: state.maxId,
            canRequestOlder: state.canRequestOlder,
          ),
        );
      }
    }

    bloc.requestOlderCompleter.complete();
    bloc.requestOlderCompleter = Completer<void>();
  }
}
