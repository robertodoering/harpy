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

    final List<TwitterListData> lists = await bloc.listsService
        .list(userId: userId, reverse: true)
        .then((List<TwitterList> lists) => lists
            .map((TwitterList list) => TwitterListData.fromTwitterList(list))
            .toList())
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
