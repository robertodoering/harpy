part of 'lists_show_bloc.dart';

abstract class ListsShowEvent {
  const ListsShowEvent();

  Stream<ListsShowState> applyAsync({
    required ListsShowState currentState,
    required ListsShowBloc bloc,
  });
}

/// Returns the first 20 owned and 20 subscribed lists.
class ShowLists extends ListsShowEvent with HarpyLogger {
  const ShowLists();

  @override
  Stream<ListsShowState> applyAsync({
    required ListsShowState currentState,
    required ListsShowBloc bloc,
  }) async* {
    log.fine('loading lists');

    yield const ListsInitialLoading();

    PaginatedTwitterLists? paginatedOwnerships;
    PaginatedTwitterLists? paginatedSubscriptions;

    final responses = await Future.wait<PaginatedTwitterLists>([
      bloc.listsService.ownerships(userId: bloc.userId),
      bloc.listsService.subscriptions(userId: bloc.userId),
    ]).handleError(twitterApiErrorHandler);

    if (responses != null && responses.length == 2) {
      paginatedOwnerships = responses[0];
      paginatedSubscriptions = responses[1];
    }

    List<TwitterListData>? ownerships;
    List<TwitterListData>? subscriptions;
    String? ownershipsCursor;
    String? subscriptionsCursor;

    if (paginatedOwnerships != null) {
      ownerships = paginatedOwnerships.lists!
          .map((list) => TwitterListData.fromTwitterList(list))
          .toList();

      ownershipsCursor = paginatedOwnerships.nextCursorStr;
    }

    if (paginatedSubscriptions != null) {
      subscriptions = paginatedSubscriptions.lists!
          .map((list) => TwitterListData.fromTwitterList(list))
          .toList();

      subscriptionsCursor = paginatedSubscriptions.nextCursorStr;
    }

    if (ownerships != null && subscriptions != null) {
      log.fine(
        'found ${ownerships.length} ownerships & '
        '${subscriptions.length} subscriptions',
      );

      if (ownerships.isNotEmpty || subscriptions.isNotEmpty) {
        yield ListsResult(
          ownerships: ownerships,
          subscriptions: subscriptions,
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
class LoadMoreOwnerships extends ListsShowEvent with HarpyLogger {
  const LoadMoreOwnerships();

  @override
  Stream<ListsShowState> applyAsync({
    required ListsShowState currentState,
    required ListsShowBloc bloc,
  }) async* {
    if (currentState is ListsResult && currentState.hasMoreOwnerships) {
      yield ListsLoadingMore.loadingOwnerships(
        ownerships: currentState.ownerships,
        subscriptions: currentState.subscriptions,
        ownershipsCursor: currentState.ownershipsCursor,
        subscriptionsCursor: currentState.subscriptionsCursor,
      );

      final paginatedOwnerships = await bloc.listsService
          .ownerships(
            userId: bloc.userId,
            cursor: currentState.ownershipsCursor,
          )
          .handleError(twitterApiErrorHandler);

      if (paginatedOwnerships != null) {
        final newOwnerships = paginatedOwnerships.lists!
            .map((list) => TwitterListData.fromTwitterList(list))
            .toList();

        final ownerships = List<TwitterListData>.of(
          currentState.ownerships.followedBy(newOwnerships),
        );

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
class LoadMoreSubscriptions extends ListsShowEvent with HarpyLogger {
  const LoadMoreSubscriptions();

  @override
  Stream<ListsShowState> applyAsync({
    required ListsShowState currentState,
    required ListsShowBloc bloc,
  }) async* {
    if (currentState is ListsResult && currentState.hasMoreSubscriptions) {
      yield ListsLoadingMore.loadingSubscriptions(
        ownerships: currentState.ownerships,
        subscriptions: currentState.subscriptions,
        ownershipsCursor: currentState.ownershipsCursor,
        subscriptionsCursor: currentState.subscriptionsCursor,
      );

      final paginatedSubscriptions = await bloc.listsService
          .subscriptions(
            userId: bloc.userId,
            cursor: currentState.subscriptionsCursor,
          )
          .handleError(twitterApiErrorHandler);

      if (paginatedSubscriptions != null) {
        final newSubscriptions = paginatedSubscriptions.lists!
            .map((list) => TwitterListData.fromTwitterList(list))
            .toList();

        final subscriptions = List<TwitterListData>.of(
          currentState.subscriptions.followedBy(newSubscriptions),
        );

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
