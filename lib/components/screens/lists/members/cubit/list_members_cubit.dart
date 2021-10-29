import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'list_members_cubit.freezed.dart';
part 'list_members_state.dart';

// TODO: use PaginatedUsersCubit

class ListMembersCubit extends Cubit<ListMembersState>
    with RequestLock, HarpyLogger {
  ListMembersCubit({
    required this.list,
  }) : super(const ListMembersState.loading()) {
    initialize();
  }

  final TwitterListData list;

  Future<void> initialize() async {
    log.fine('load list members');

    emit(const ListMembersState.loading());

    final paginatedUsers = await app<TwitterApi>()
        .listsService
        .members(listId: list.idStr)
        .handleError(twitterApiErrorHandler);

    if (paginatedUsers != null && paginatedUsers.users != null) {
      final members = paginatedUsers.users!
          .map((user) => UserData.fromUser(user))
          .toBuiltList();

      if (members.isNotEmpty) {
        emit(
          ListMembersState.data(
            members: members,
            membersCursor: paginatedUsers.nextCursorStr,
          ),
        );
      } else {
        emit(const ListMembersState.noData());
      }
    } else {
      emit(const ListMembersState.error());
    }
  }

  Future<void> loadMore() async {
    if (lock()) {
      return;
    }

    final currentState = state;

    if (currentState is _ListMembersStateData && currentState.hasMoreData) {
      log.fine('load more members');

      emit(ListMembersState.loadingMore(members: currentState.members));

      final paginatedMembers = await app<TwitterApi>()
          .listsService
          .members(listId: list.idStr, cursor: currentState.membersCursor)
          .handleError(twitterApiErrorHandler);

      if (paginatedMembers != null && paginatedMembers.users != null) {
        final members = paginatedMembers.users!.map(
          (user) => UserData.fromUser(user),
        );

        emit(
          ListMembersState.data(
            members: currentState.members.followedBy(members).toBuiltList(),
            membersCursor: paginatedMembers.nextCursorStr,
          ),
        );
      } else {
        emit(
          ListMembersState.data(
            members: currentState.members,
            membersCursor: null,
          ),
        );
      }
    }
  }
}
