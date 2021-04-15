part of 'show_lists_bloc.dart';

abstract class ShowListsEvent {
  const ShowListsEvent();

  Stream<ShowListsState> applyAsync({
    ShowListsState currentState,
    ShowListsBloc bloc,
  });
}

/// Returns the first 100 lists the authenticating or specified user subscribes
/// to, including their own.
///
/// Their own lists are returned first, followed by subscribed lists.
class ShowLists extends ShowListsEvent with HarpyLogger {
  const ShowLists();

  @override
  Stream<ShowListsState> applyAsync({
    ShowListsState currentState,
    ShowListsBloc bloc,
  }) async* {
    log.fine('loading lists');

    yield const ListsInitialLoading();

    PaginatedTwitterLists paginatedOwnerships;
    PaginatedTwitterLists paginatedSubscriptions;

    final List<PaginatedTwitterLists> responses = await Future.wait<
        PaginatedTwitterLists>(<Future<PaginatedTwitterLists>>[
      bloc.listsService.ownerships(userId: bloc.userId),
      bloc.listsService.subscriptions(
        params: <String, String>{
          if (bloc.userId != null) 'user_id': bloc.userId,
        },
      ),
    ]).catchError(twitterApiErrorHandler);

    if (responses != null && responses.length == 2) {
      paginatedOwnerships = responses[0];
      paginatedSubscriptions = responses[1];
    }

    List<TwitterListData> ownerships;
    List<TwitterListData> subscriptions;
    String ownershipsCursor;
    String subscriptionsCursor;

    if (paginatedOwnerships != null) {
      ownerships = paginatedOwnerships.lists
          .map((TwitterList list) => TwitterListData.fromTwitterList(list))
          .toList();

      ownershipsCursor = paginatedOwnerships.nextCursorStr;
    }

    if (paginatedSubscriptions != null) {
      subscriptions = paginatedSubscriptions.lists
          .map((TwitterList list) => TwitterListData.fromTwitterList(list))
          .toList();

      subscriptionsCursor = paginatedSubscriptions.nextCursorStr;
    }

    if (ownerships != null && subscriptions != null) {
      log.fine('found ${ownerships.length} ownerships & '
          '${subscriptions.length} subscriptions');

      if (ownerships.isNotEmpty || subscriptions != null) {
        yield ListsResult(
          ownerships: ownerships ?? <TwitterList>[],
          subscriptions: subscriptions ?? <TwitterList>[],
          ownershipsCursor: ownershipsCursor,
          subscriptionsCursor: subscriptionsCursor,
        );
      } else {
        yield const ListsNoResult();
      }
    } else {
      yield const ListsFailure();
    }
  }
}

/// Loads the next page for the owned lists.
///
/// Does nothing if no more owned lists exist or if the current state is not
/// [ListsResult].
class LoadMoreOwnerships extends ShowListsEvent with HarpyLogger {
  const LoadMoreOwnerships();

  @override
  Stream<ShowListsState> applyAsync({
    ShowListsState currentState,
    ShowListsBloc bloc,
  }) async* {
    if (currentState is ListsResult && currentState.hasMoreOwnerships) {
      yield ListsLoadingMore.loadingOwnerships(
        ownerships: currentState.ownerships,
        subscriptions: currentState.subscriptions,
        ownershipsCursor: currentState.ownershipsCursor,
        subscriptionsCursor: currentState.subscriptionsCursor,
      );

      final PaginatedTwitterLists paginatedOwnerships = await bloc.listsService
          .ownerships(
            userId: bloc.userId,
            cursor: int.tryParse(currentState.ownershipsCursor),
          )
          .catchError(twitterApiErrorHandler);

      if (paginatedOwnerships != null) {
        final List<TwitterListData> newOwnerships = paginatedOwnerships.lists
            .map((TwitterList list) => TwitterListData.fromTwitterList(list))
            .toList();

        final List<TwitterListData> ownerships = List<TwitterListData>.of(
            currentState.ownerships.followedBy(newOwnerships));

        yield ListsResult(
          ownerships: ownerships,
          subscriptions: currentState.subscriptions,
          ownershipsCursor: paginatedOwnerships.nextCursorStr,
          subscriptionsCursor: currentState.subscriptionsCursor,
        );
      } else {
        yield ListsResult(
          ownerships: currentState.ownerships,
          subscriptions: currentState.subscriptions,
          ownershipsCursor: null,
          subscriptionsCursor: currentState.subscriptionsCursor,
        );
      }
    }
  }
}

/// Loads the next page for the subscribed lists.
///
/// Does nothing if no more subscribed lists exist or if the current state is
/// not [ListsResult].
class LoadMoreSubscriptions extends ShowListsEvent with HarpyLogger {
  const LoadMoreSubscriptions();

  @override
  Stream<ShowListsState> applyAsync({
    ShowListsState currentState,
    ShowListsBloc bloc,
  }) async* {
    if (currentState is ListsResult && currentState.hasMoreSubscriptions) {
      yield ListsLoadingMore.loadingSubscriptions(
        ownerships: currentState.ownerships,
        subscriptions: currentState.subscriptions,
        ownershipsCursor: currentState.ownershipsCursor,
        subscriptionsCursor: currentState.subscriptionsCursor,
      );

      final PaginatedTwitterLists paginatedSubscriptions =
          await bloc.listsService.subscriptions(
        params: <String, String>{
          if (bloc.userId != null) 'user_id': bloc.userId,
          'cursor': currentState.subscriptionsCursor,
        },
      ).catchError(twitterApiErrorHandler);

      if (paginatedSubscriptions != null) {
        final List<TwitterListData> newSubscriptions = paginatedSubscriptions
            .lists
            .map((TwitterList list) => TwitterListData.fromTwitterList(list))
            .toList();

        final List<TwitterListData> subscriptions = List<TwitterListData>.of(
            currentState.subscriptions.followedBy(newSubscriptions));

        yield ListsResult(
          ownerships: currentState.ownerships,
          subscriptions: subscriptions,
          ownershipsCursor: currentState.ownershipsCursor,
          subscriptionsCursor: paginatedSubscriptions.nextCursorStr,
        );
      } else {
        yield ListsResult(
          ownerships: currentState.ownerships,
          subscriptions: currentState.subscriptions,
          ownershipsCursor: currentState.ownershipsCursor,
          subscriptionsCursor: null,
        );
      }
    }
  }
}
