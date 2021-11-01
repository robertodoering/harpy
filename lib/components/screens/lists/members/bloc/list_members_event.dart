part of 'list_members_bloc.dart';

abstract class ListMembersEvent {
  const ListMembersEvent();

  Future<void> handle(ListMembersBloc bloc, Emitter emit);
}

class ShowListMembers extends ListMembersEvent with HarpyLogger {
  const ShowListMembers();

  @override
  Future<void> handle(ListMembersBloc bloc, Emitter emit) async {
    log.fine('load list members');

    emit(const ListMembersInitialLoading());

    final paginatedUsers = await bloc.listsService
        .members(listId: bloc.list.idStr)
        .handleError(twitterApiErrorHandler);

    if (paginatedUsers != null && paginatedUsers.users != null) {
      final members =
          paginatedUsers.users!.map((user) => UserData.fromUser(user)).toList();

      if (members.isNotEmpty) {
        emit(
          ListMembersResult(
            members: members,
            membersCursor: paginatedUsers.nextCursorStr,
          ),
        );
      } else {
        emit(const NoListMembersResult());
      }
    } else {
      emit(const ListMembersFailure());
    }
  }
}

class LoadMoreMembers extends ListMembersEvent with HarpyLogger {
  const LoadMoreMembers();

  @override
  Future<void> handle(ListMembersBloc bloc, Emitter emit) async {
    final state = bloc.state;

    if (state is ListMembersResult && state.hasMoreData) {
      log.fine('load more members');

      emit(
        MembersLoadingMore(
          members: state.members,
          membersCursor: state.membersCursor,
        ),
      );

      final paginatedMembers = await bloc.listsService
          .members(listId: bloc.list.idStr, cursor: state.membersCursor)
          .handleError(twitterApiErrorHandler);

      if (paginatedMembers != null) {
        final members = List<UserData>.of(
          state.members.followedBy(
            paginatedMembers.users!
                .map((user) => UserData.fromUser(user))
                .toList(),
          ),
        );

        emit(
          ListMembersResult(
            members: members,
            membersCursor: paginatedMembers.nextCursorStr,
          ),
        );
      } else {
        emit(
          ListMembersResult(
            members: state.members,
            membersCursor: null,
          ),
        );
      }
    }

    bloc.requestMoreCompleter.complete();
    bloc.requestMoreCompleter = Completer<void>();
  }
}
