import 'package:dart_twitter_api/api/users/data/paginated_users.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_bloc.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_event.dart';
import 'package:harpy/components/following/bloc/following_bloc.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/twitter/user_data.dart';

/// Loads the following users and sets it to the [FollowingBloc.users];
class LoadFollowingUsers extends LoadPaginatedData {
  const LoadFollowingUsers();

  @override
  Future<bool> loadData(PaginatedBloc bloc) async {
    final FollowingBloc followingBloc = bloc as FollowingBloc;

    final PaginatedUsers paginatedUsers = await followingBloc.userService
        .friendsList(
          userId: followingBloc.userId,
          skipStatus: true,
          count: 200,
          cursor: bloc.cursor,
        )
        .catchError(twitterApiErrorHandler);

    if (paginatedUsers == null) {
      return false;
    } else {
      followingBloc.cursor = int.tryParse(paginatedUsers.nextCursorStr);
      followingBloc.users.addAll(
        paginatedUsers.users.map((User user) => UserData.fromUser(user)),
      );

      return true;
    }
  }
}
