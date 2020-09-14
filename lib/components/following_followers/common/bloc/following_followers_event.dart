import 'package:dart_twitter_api/api/users/data/paginated_users.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_bloc.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_event.dart';
import 'package:harpy/components/following_followers/common/bloc/following_followers_bloc.dart';
import 'package:harpy/core/api/twitter/user_data.dart';

/// Loads the users and sets it to the [FollowingFollowersBloc.users];
abstract class LoadUsers extends LoadPaginatedData {
  const LoadUsers();

  /// Used to request the [PaginatedUsers] for the [FollowersBloc] or
  /// [FollowingBloc].
  Future<PaginatedUsers> requestUsers(FollowingFollowersBloc bloc);

  @override
  Future<bool> loadData(PaginatedBloc paginatedBloc) async {
    final FollowingFollowersBloc bloc = paginatedBloc as FollowingFollowersBloc;

    final PaginatedUsers paginatedUsers = await requestUsers(bloc);

    if (paginatedUsers == null) {
      return false;
    } else {
      bloc.cursor = int.tryParse(paginatedUsers.nextCursorStr);
      bloc.users.addAll(
        paginatedUsers.users.map((User user) => UserData.fromUser(user)),
      );

      return true;
    }
  }
}
