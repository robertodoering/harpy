part of 'list_member_bloc.dart';

abstract class ListMemberEvent {
  const ListMemberEvent();

  Stream<ListMemberState> applyAsync({
    required ListMemberState currentState,
    required ListMemberBloc bloc,
  });
}

class ShowListMembers extends ListMemberEvent with HarpyLogger {
  const ShowListMembers();

  @override
  Stream<ListMemberState> applyAsync({
    required ListMemberState currentState,
    required ListMemberBloc bloc,
  }) async* {
    log.fine('load list members');

    yield const ListMemberInitialLoading();

    final paginatedUsers = await bloc.listsService
        .members(listId: bloc.list.idStr)
        .handleError(twitterApiErrorHandler);

    if (paginatedUsers != null) {
      final members =
          paginatedUsers.users!.map((user) => UserData.fromUser(user)).toList();

      if (members.isNotEmpty) {
        yield ListMembersResult(
          members: members,
          membersCursor: paginatedUsers.nextCursorStr!,
        );
      } else {
        yield const NoListMembersResult();
      }
    } else {
      yield const ListMemberFailure();
    }
  }
}

class LoadMoreMembers extends ListMemberEvent with HarpyLogger {
  @override
  Stream<ListMemberState> applyAsync({
    required ListMemberState currentState,
    required ListMemberBloc bloc,
  }) async* {
    if (currentState is ListMembersResult && currentState.hasMoreData) {
      log.fine('load more members');

      yield MembersLoadingMore(
        members: currentState.members,
        membersCursor: currentState.membersCursor,
      );

      final paginatedMembers = await bloc.listsService
          .members(listId: bloc.list.idStr, cursor: currentState.membersCursor)
          .catchError(twitterApiErrorHandler);

      final members = List<UserData>.of(
        currentState.members.followedBy(
          paginatedMembers.users!
              .map((user) => UserData.fromUser(user))
              .toList(),
        ),
      );

      yield ListMembersResult(
        members: members,
        membersCursor: paginatedMembers.nextCursorStr!,
      );
    }
  }
}
