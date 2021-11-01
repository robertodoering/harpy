part of 'following_bloc.dart';

class LoadFollowingUsers extends LoadUsers {
  const LoadFollowingUsers();

  @override
  Future<PaginatedUsers?> requestUsers(FollowingFollowersBloc bloc) {
    return app<TwitterApi>()
        .userService
        .friendsList(
          userId: bloc.userId,
          skipStatus: true,
          count: 200,
          cursor: bloc.cursor,
        )
        .handleError(twitterApiErrorHandler);
  }
}
