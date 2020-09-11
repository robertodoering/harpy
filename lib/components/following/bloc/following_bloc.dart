import 'dart:async';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/following/bloc/following_event.dart';
import 'package:harpy/components/following/bloc/following_state.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
import 'package:harpy/core/service_locator.dart';

class FollowingBloc extends Bloc<FollowingEvent, FollowingState> {
  FollowingBloc({
    @required this.userId,
  }) : super(LoadingFollowingState()) {
    add(const LoadFollowingUsersEvent());
  }

  /// The id of the user for whom to load the followers.
  final String userId;

  final UserService userService = app<TwitterApi>().userService;

  /// The list of following users for the user with the [userId].
  List<UserData> users = <UserData>[];

  /// The cursor for the paginated request.
  int cursor = -1;

  /// Whether the initial following user list is being loaded.
  bool get showInitialLoading =>
      users.isEmpty && state is LoadingFollowingState;

  /// Whether the next page of following users is being loaded.
  bool get showLoadingMore =>
      users.isNotEmpty && state is LoadingFollowingState;

  /// Whether no following users exist.
  bool get showNoFollowing => users.isEmpty && state is LoadedFollowingState;

  /// Whether to show an error message.
  bool get showError => state is FailedLoadingFollowingState;

  /// Whether more followers can be loaded.
  bool get hasNextPage => cursor != null;

  static FollowingBloc of(BuildContext context) =>
      BlocProvider.of<FollowingBloc>(context);

  @override
  Stream<FollowingState> mapEventToState(
    FollowingEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
