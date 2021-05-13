part of 'list_members_bloc.dart';

abstract class ListMembersEvent {
  const ListMembersEvent();

  Stream<ListMembersState> applyAsync({
    required ListMembersState currentState,
    required ListMembersBloc bloc,
  });
}

class ShowListMembers extends ListMembersEvent with HarpyLogger {
  const ShowListMembers();

  @override
  Stream<ListMembersState> applyAsync({
    required ListMembersState currentState,
    required ListMembersBloc bloc,
  }) async* {
    log.fine('load list members');

    yield const ListMembersInitialLoading();

    final paginatedUsers = await bloc.listsService
        .members(listId: bloc.list.idStr)
        .handleError(twitterApiErrorHandler);

    if (paginatedUsers != null && paginatedUsers.users != null) {
      final members =
          paginatedUsers.users!.map((user) => UserData.fromUser(user)).toList();

      if (members.isNotEmpty) {
        yield ListMembersResult(
          members: members,
          membersCursor: paginatedUsers.nextCursorStr,
        );
      } else {
        yield const NoListMembersResult();
      }
    } else {
      yield const ListMembersFailure();
    }
  }
}

class LoadMoreMembers extends ListMembersEvent with HarpyLogger {
  const LoadMoreMembers();

  @override
  Stream<ListMembersState> applyAsync({
    required ListMembersState currentState,
    required ListMembersBloc bloc,
  }) async* {
    if (currentState is ListMembersResult && currentState.hasMoreData) {
      log.fine('load more members');

      yield MembersLoadingMore(
        members: currentState.members,
        membersCursor: currentState.membersCursor,
      );

      final paginatedMembers = await bloc.listsService
          .members(listId: bloc.list.idStr, cursor: currentState.membersCursor)
          .handleError(twitterApiErrorHandler);

      if (paginatedMembers != null) {
        final members = List<UserData>.of(
          currentState.members.followedBy(
            paginatedMembers.users!
                .map((user) => UserData.fromUser(user))
                .toList(),
          ),
        );

        yield ListMembersResult(
          members: members,
          membersCursor: paginatedMembers.nextCursorStr,
        );
      } else {
        yield ListMembersResult(
          members: currentState.members,
          membersCursor: null,
        );
      }
    }

    bloc.requestMoreCompleter.complete();
    bloc.requestMoreCompleter = Completer<void>();
  }
}
