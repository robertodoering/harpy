import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// Implementation for a [PaginatedCubitMixin] to handle [PaginatedUsers]
/// responses.
///
/// For example implementations, see:
/// * [FollowersCubit]
/// * [FollowingCubit]
/// * [ListMembersCubit]
abstract class PaginatedUsersCubit
    extends Cubit<PaginatedState<BuiltList<UserData>>>
    with
        RequestLock,
        HarpyLogger,
        PaginatedCubitMixin<PaginatedUsers, BuiltList<UserData>> {
  PaginatedUsersCubit(PaginatedState<BuiltList<UserData>> initialState)
      : super(initialState);

  @override
  Future<void> onInitialResponse(PaginatedUsers response) async {
    log.fine('received initial paginated users response');

    final users = response.users?.map(UserData.fromUser).toBuiltList();

    if (users == null || users.isEmpty) {
      emit(const PaginatedState.noData());
    } else {
      final cursor = int.tryParse(response.nextCursorStr ?? '');

      emit(
        PaginatedState.data(
          data: users,
          cursor: cursor,
        ),
      );
    }
  }

  @override
  Future<void> onMoreResponse(
    PaginatedUsers response,
    BuiltList<UserData> data,
  ) async {
    log.fine('received loading more paginated users response');

    final users = response.users?.map(UserData.fromUser) ?? [];

    final cursor = int.tryParse(response.nextCursorStr ?? '');

    emit(
      PaginatedState.data(
        data: data.followedBy(users).toBuiltList(),
        cursor: cursor,
      ),
    );
  }
}
