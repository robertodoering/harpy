part of 'lists_show_bloc.dart';

abstract class ListsShowEvent {
  const ListsShowEvent();

  Future<void> handle(ListsShowBloc bloc, Emitter emit);
}

/// Returns the first 20 owned and 20 subscribed lists.
class ShowLists extends ListsShowEvent with HarpyLogger {
  const ShowLists();

  @override
  Future<void> handle(ListsShowBloc bloc, Emitter emit) async {
    log.fine('loading lists');

    emit(const ListsInitialLoading());

    PaginatedTwitterLists? paginatedOwnerships;
    PaginatedTwitterLists? paginatedSubscriptions;

    final responses = await Future.wait([
      app<TwitterApi>().listsService.ownerships(userId: bloc.userId),
      app<TwitterApi>().listsService.subscriptions(userId: bloc.userId),
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
        emit(
          ListsResult(
            ownerships: ownerships,
            subscriptions: subscriptions,
            ownershipsCursor: ownershipsCursor,
            subscriptionsCursor: subscriptionsCursor,
          ),
        );
      } else {
        emit(const ListsNoResult());
      }
    } else {
      emit(const ListsFailure());
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
  Future<void> handle(ListsShowBloc bloc, Emitter emit) async {
    final state = bloc.state;

    if (state is ListsResult && state.hasMoreOwnerships) {
      emit(
        ListsLoadingMore.loadingOwnerships(
          ownerships: state.ownerships,
          subscriptions: state.subscriptions,
          ownershipsCursor: state.ownershipsCursor,
          subscriptionsCursor: state.subscriptionsCursor,
        ),
      );

      final paginatedOwnerships = await app<TwitterApi>()
          .listsService
          .ownerships(
            userId: bloc.userId,
            cursor: state.ownershipsCursor,
          )
          .handleError(twitterApiErrorHandler);

      if (paginatedOwnerships != null) {
        final newOwnerships = paginatedOwnerships.lists!
            .map((list) => TwitterListData.fromTwitterList(list))
            .toList();

        final ownerships = List.of(
          state.ownerships.followedBy(newOwnerships),
        );

        emit(
          ListsResult(
            ownerships: ownerships,
            subscriptions: state.subscriptions,
            ownershipsCursor: paginatedOwnerships.nextCursorStr,
            subscriptionsCursor: state.subscriptionsCursor,
          ),
        );
      } else {
        emit(
          ListsResult(
            ownerships: state.ownerships,
            subscriptions: state.subscriptions,
            ownershipsCursor: null,
            subscriptionsCursor: state.subscriptionsCursor,
          ),
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
  Future<void> handle(ListsShowBloc bloc, Emitter emit) async {
    final state = bloc.state;

    if (state is ListsResult && state.hasMoreSubscriptions) {
      emit(
        ListsLoadingMore.loadingSubscriptions(
          ownerships: state.ownerships,
          subscriptions: state.subscriptions,
          ownershipsCursor: state.ownershipsCursor,
          subscriptionsCursor: state.subscriptionsCursor,
        ),
      );

      final paginatedSubscriptions = await app<TwitterApi>()
          .listsService
          .subscriptions(
            userId: bloc.userId,
            cursor: state.subscriptionsCursor,
          )
          .handleError(twitterApiErrorHandler);

      if (paginatedSubscriptions != null) {
        final newSubscriptions = paginatedSubscriptions.lists!
            .map((list) => TwitterListData.fromTwitterList(list))
            .toList();

        final subscriptions = List.of(
          state.subscriptions.followedBy(newSubscriptions),
        );

        emit(
          ListsResult(
            ownerships: state.ownerships,
            subscriptions: subscriptions,
            ownershipsCursor: state.ownershipsCursor,
            subscriptionsCursor: paginatedSubscriptions.nextCursorStr,
          ),
        );
      } else {
        emit(
          ListsResult(
            ownerships: state.ownerships,
            subscriptions: state.subscriptions,
            ownershipsCursor: state.ownershipsCursor,
            subscriptionsCursor: null,
          ),
        );
      }
    }
  }
}
