part of 'following_bloc.dart';

/// Loads the following users and sets it to the [FollowingBloc.users];
class LoadFollowingUsers extends LoadUsers {
  const LoadFollowingUsers();

  @override
  Future<PaginatedUsers?> requestUsers(FollowingFollowersBloc? bloc) {
    return bloc!.userService
        .friendsList(
          userId: bloc.userId,
          skipStatus: true,
          count: 200,
          cursor: bloc.cursor,
        )
        .handleError(twitterApiErrorHandler);
  }
}
