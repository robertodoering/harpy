part of 'lists_show_bloc.dart';

abstract class ListsShowEvent {
  const ListsShowEvent();

  const factory ListsShowEvent.show() = _Show;
  const factory ListsShowEvent.loadMoreOwnerships() = _LoadMoreOwnerships;
  const factory ListsShowEvent.loadMoreSubscriptions() = _LoadMoreSubscriptions;

  Future<void> handle(ListsShowBloc bloc, Emitter emit);
}

class _Show extends ListsShowEvent with HarpyLogger {
  const _Show();

  @override
  Future<void> handle(ListsShowBloc bloc, Emitter emit) async {
    log.fine('loading lists');

    emit(const ListsShowState.loading());

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

    BuiltList<TwitterListData>? ownerships;
    BuiltList<TwitterListData>? subscriptions;
    String? ownershipsCursor;
    String? subscriptionsCursor;

    if (paginatedOwnerships != null) {
      ownerships = paginatedOwnerships.lists!
          .map(TwitterListData.fromTwitterList)
          .toBuiltList();

      ownershipsCursor = paginatedOwnerships.nextCursorStr;
    }

    if (paginatedSubscriptions != null) {
      subscriptions = paginatedSubscriptions.lists!
          .map(TwitterListData.fromTwitterList)
          .toBuiltList();

      subscriptionsCursor = paginatedSubscriptions.nextCursorStr;
    }

    if (ownerships != null && subscriptions != null) {
      log.fine(
        'found ${ownerships.length} ownerships & '
        '${subscriptions.length} subscriptions',
      );

      if (ownerships.isNotEmpty || subscriptions.isNotEmpty) {
        emit(
          ListsShowState.data(
            ownerships: ownerships,
            subscriptions: subscriptions,
            ownershipsCursor: ownershipsCursor,
            subscriptionsCursor: subscriptionsCursor,
          ),
        );
      } else {
        emit(const ListsShowState.noData());
      }
    } else {
      emit(const ListsShowState.error());
    }
  }
}

class _LoadMoreOwnerships extends ListsShowEvent with HarpyLogger {
  const _LoadMoreOwnerships();

  @override
  Future<void> handle(ListsShowBloc bloc, Emitter emit) async {
    final state = bloc.state;

    if (state is _Data && state.hasMoreOwnerships) {
      emit(
        ListsShowState.loadingMoreOwnerships(
          ownerships: state.ownerships,
          subscriptions: state.subscriptions,
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
            .map(TwitterListData.fromTwitterList)
            .toList();

        final ownerships =
            state.ownerships.followedBy(newOwnerships).toBuiltList();

        emit(
          ListsShowState.data(
            ownerships: ownerships,
            subscriptions: state.subscriptions,
            ownershipsCursor: paginatedOwnerships.nextCursorStr,
            subscriptionsCursor: state.subscriptionsCursor,
          ),
        );
      } else {
        emit(
          ListsShowState.data(
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

class _LoadMoreSubscriptions extends ListsShowEvent with HarpyLogger {
  const _LoadMoreSubscriptions();

  @override
  Future<void> handle(ListsShowBloc bloc, Emitter emit) async {
    final state = bloc.state;

    if (state is _Data && state.hasMoreSubscriptions) {
      emit(
        ListsShowState.loadingMoreSubscriptions(
          ownerships: state.ownerships,
          subscriptions: state.subscriptions,
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
        final newSubscriptions =
            paginatedSubscriptions.lists!.map(TwitterListData.fromTwitterList);

        final subscriptions =
            state.subscriptions.followedBy(newSubscriptions).toBuiltList();

        emit(
          ListsShowState.data(
            ownerships: state.ownerships,
            subscriptions: subscriptions,
            ownershipsCursor: state.ownershipsCursor,
            subscriptionsCursor: paginatedSubscriptions.nextCursorStr,
          ),
        );
      } else {
        emit(
          ListsShowState.data(
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
