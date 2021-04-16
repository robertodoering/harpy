part of 'list_timeline_bloc.dart';

abstract class ListTimelineEvent {
  const ListTimelineEvent();

  Stream<ListTimelineState> applyAsync({
    ListTimelineState currentState,
    ListTimelineBloc bloc,
  });
}

/// Requests the newest 200 tweets for a list.
class RequestListTimeline extends ListTimelineEvent with HarpyLogger {
  const RequestListTimeline();

  @override
  Stream<ListTimelineState> applyAsync({
    ListTimelineState currentState,
    ListTimelineBloc bloc,
  }) async* {
    log.fine('requesting list timeline');

    yield const ListTimelineLoading();

    final List<TweetData> tweets = await bloc.listsService
        .statuses(listId: bloc.listId, count: 200)
        .then(handleTweets)
        .catchError(twitterApiErrorHandler);

    if (tweets != null) {
      log.fine('found ${tweets.length} list tweets');

      if (tweets.isNotEmpty) {
        yield ListTimelineResult(tweets: tweets);
      } else {
        yield const ListTimelineNoResult();
      }
    } else {
      yield const ListTimelineFailure();
    }
  }
}
