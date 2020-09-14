import 'package:dart_twitter_api/api/users/data/paginated_users.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/components/following_followers/common/bloc/following_followers_bloc.dart';
import 'package:harpy/components/following_followers/common/bloc/following_followers_event.dart';
import 'package:harpy/core/api/network_error_handler.dart';

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
