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
      final members = paginatedUsers.users!;

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
