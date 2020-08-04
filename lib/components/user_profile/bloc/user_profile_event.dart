import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_state.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/twitter/user_data.dart';

@immutable
abstract class UserProfileEvent {
  const UserProfileEvent();

  Stream<UserProfileState> applyAsync({
    UserProfileState currentState,
    UserProfileBloc bloc,
  });
}

/// Loads the user data for the [userId] and sets it to the
/// [UserProfileBloc.user].
class LoadUserEvent extends UserProfileEvent {
  const LoadUserEvent(this.userId);

  final String userId;

  @override
  Stream<UserProfileState> applyAsync({
    UserProfileState currentState,
    UserProfileBloc bloc,
  }) async* {
    yield LoadingUserState();

    bloc.user = await bloc.userService
        .usersShow(userId: userId)
        .then((User user) => UserData.fromUser(user))
        .catchError(silentErrorHandler);

    if (bloc.user == null) {
      yield FailedLoadingUserState();
    } else {
      yield InitializedState();
    }
  }
}

/// Follows the [bloc.user].
class FollowUserEvent extends UserProfileEvent {
  const FollowUserEvent();

  @override
  Stream<UserProfileState> applyAsync({
    UserProfileState currentState,
    UserProfileBloc bloc,
  }) async* {
    // todo
  }
}

/// Unfollows the [bloc.user].
class UnfollowUserEvent extends UserProfileEvent {
  const UnfollowUserEvent();

  @override
  Stream<UserProfileState> applyAsync({
    UserProfileState currentState,
    UserProfileBloc bloc,
  }) async* {
    // todo
  }
}
