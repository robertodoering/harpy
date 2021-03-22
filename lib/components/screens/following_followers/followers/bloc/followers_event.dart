part of 'followers_bloc.dart';

/// Loads the followers and sets it to the [FollowingBloc.users];
class LoadFollowers extends LoadUsers {
  const LoadFollowers();

  @override
  Future<PaginatedUsers> requestUsers(FollowingFollowersBloc bloc) {
    return bloc.userService
        .followersList(
          userId: bloc.userId,
          skipStatus: true,
          count: 200,
          cursor: bloc.cursor,
        )
        .catchError(twitterApiErrorHandler);
  }
}
