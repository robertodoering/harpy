part of 'lists_bloc.dart';

abstract class ListsEvent {
  const ListsEvent();

  Stream<ListsState> applyAsync({
    ListsState currentState,
    ListsBloc bloc,
  });
}

/// Returns the first 100 lists the authenticating or specified user subscribes
/// to, including their own.
///
/// Their own lists are returned first, followed by subscribed lists.
class ShowLists extends ListsEvent with HarpyLogger {
  const ShowLists({
    this.userId,
  });

  /// The id of the user whose list to show.
  ///
  /// When `null`, the authenticated user's lists will be returned.
  final String userId;

  @override
  Stream<ListsState> applyAsync({
    ListsState currentState,
    ListsBloc bloc,
  }) async* {
    log.fine('loading lists');

    yield const ListsInitialLoading();

    final List<TwitterList> lists = await bloc.listsService
        .list(userId: userId, reverse: true)
        .catchError(twitterApiErrorHandler);

    if (lists != null) {
      log.fine('found ${lists.length} lists');

      if (lists.isNotEmpty) {
        yield ListsResult(lists: lists);
      } else {
        yield const ListsNoResult();
      }
    } else {
      yield const ListsFailure();
    }
  }
}
