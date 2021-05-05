part of 'following_followers_bloc.dart';

/// Loads the users and sets it to the [FollowingFollowersBloc.users];
abstract class LoadUsers extends LoadPaginatedData {
  const LoadUsers();

  /// Used to request the [PaginatedUsers] for the [FollowersBloc] or
  /// [FollowingBloc].
  Future<PaginatedUsers?> requestUsers(FollowingFollowersBloc? bloc);

  @override
  Future<bool> loadData(PaginatedBloc? paginatedBloc) async {
    final FollowingFollowersBloc? bloc =
        paginatedBloc as FollowingFollowersBloc?;

    final PaginatedUsers? paginatedUsers = await requestUsers(bloc);

    if (paginatedUsers == null) {
      return false;
    } else {
      bloc!.cursor = int.tryParse(paginatedUsers.nextCursorStr!);
      bloc.users.addAll(
        paginatedUsers.users!.map((User user) => UserData.fromUser(user)),
      );

      return true;
    }
  }
}
