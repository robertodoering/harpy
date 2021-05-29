part of 'list_timeline_bloc.dart';

abstract class ListTimelineEvent {
  const ListTimelineEvent();

  Stream<ListTimelineState> applyAsync({
    required ListTimelineState currentState,
    required ListTimelineBloc bloc,
  });
}

/// Requests the newest 200 tweets for a list.
class RequestListTimeline extends ListTimelineEvent with HarpyLogger {
  const RequestListTimeline();

  @override
  Stream<ListTimelineState> applyAsync({
    required ListTimelineState currentState,
    required ListTimelineBloc bloc,
  }) async* {
    log.fine('requesting list timeline');

    yield const ListTimelineLoading();

    final tweets = await bloc.listsService
        .statuses(listId: bloc.listId, count: 200)
        .then(handleTweets)
        .handleError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} list tweets');

      if (tweets.isNotEmpty) {
        yield ListTimelineResult(
          tweets: tweets,
          maxId: tweets.last.id,
        );
      } else {
        yield const ListTimelineNoResult();
      }
    } else {
      yield const ListTimelineFailure();
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
  Stream<ListTimelineState> applyAsync({
    required ListTimelineState currentState,
    required ListTimelineBloc bloc,
  }) async* {
    if (bloc.lock()) {
      bloc.requestOlderCompleter.complete();
      bloc.requestOlderCompleter = Completer<void>();
      return;
    }

    if (currentState is ListTimelineResult) {
      final maxId = _findMaxId(currentState);

      if (maxId == null) {
        log.info('tried to request older but max id was null');
        return;
      }

      log.fine('requesting older list timeline');

      yield ListTimelineLoadingOlder(oldResult: currentState);

      final tweets = await bloc.listsService
          .statuses(listId: bloc.listId, count: 200, maxId: maxId)
          .then(handleTweets)
          .handleError(twitterApiErrorHandler);

      if (tweets != null) {
        log.fine('found ${tweets.length} older list tweets');

        yield ListTimelineResult(
          tweets: currentState.tweets.followedBy(tweets).toList(),
          maxId: tweets.last.id,
          canRequestOlder: tweets.isNotEmpty,
        );
      } else {
        yield ListTimelineResult(
          tweets: currentState.tweets,
          maxId: currentState.maxId,
          canRequestOlder: currentState.canRequestOlder,
        );
      }
    }

    bloc.requestOlderCompleter.complete();
    bloc.requestOlderCompleter = Completer<void>();
  }
}
