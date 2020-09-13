import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_bloc.dart';
import 'package:harpy/components/following/bloc/following_event.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
import 'package:harpy/core/service_locator.dart';

class FollowingBloc extends PaginatedBloc {
  FollowingBloc({
    @required this.userId,
  }) {
    add(const LoadFollowingUsers());
  }

  /// The id of the user for whom to load the followers.
  final String userId;

  final UserService userService = app<TwitterApi>().userService;

  /// The list of following users for the user with the [userId].
  List<UserData> users = <UserData>[];

  @override
  bool get hasData => users.isNotEmpty;

  static FollowingBloc of(BuildContext context) =>
      BlocProvider.of<FollowingBloc>(context);
}
