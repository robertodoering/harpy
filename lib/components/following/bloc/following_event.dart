import 'package:dart_twitter_api/api/users/data/paginated_users.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/following/bloc/following_bloc.dart';
import 'package:harpy/components/following/bloc/following_state.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
import 'package:logging/logging.dart';

@immutable
abstract class FollowingEvent {
  const FollowingEvent();

  Stream<FollowingState> applyAsync({
    FollowingState currentState,
    FollowingBloc bloc,
  });
}

/// Loads the next page of following users for the [FollowingBloc.userId] and
/// sets it to the [FollowingBloc.users].
class LoadFollowingUsersEvent extends FollowingEvent {
  const LoadFollowingUsersEvent();

  static final Logger _log = Logger('LoadFollowersEvent');

  @override
  Stream<FollowingState> applyAsync({
    FollowingState currentState,
    FollowingBloc bloc,
  }) async* {
    _log.fine('loading following');

    if (bloc.cursor == null) {
      return;
    }

    yield LoadingFollowingState();

    final PaginatedUsers paginatedUsers = await bloc.userService
        .followersList(
          userId: bloc.userId,
          skipStatus: true,
          count: 200,
          cursor: bloc.cursor,
        )
        .catchError(twitterApiErrorHandler);

    if (paginatedUsers == null) {
      yield FailedLoadingFollowingState();
    } else {
      bloc.cursor = int.tryParse(paginatedUsers.nextCursorStr);
      bloc.users.addAll(
        paginatedUsers.users.map((User user) => UserData.fromUser(user)),
      );

      yield LoadedFollowingState();
    }
  }
}
