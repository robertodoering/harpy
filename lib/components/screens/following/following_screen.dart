import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

/// Builds the screen with a list of the following users for the specified user.
///
/// NOTE: "Following users" are also referred to as "friends" in the twitter
///  api.
class FollowingScreen extends StatelessWidget {
  const FollowingScreen({
    required this.userId,
  });

  /// The [userId] of the user whom to search the followers for.
  final String userId;

  static const route = 'following';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaginatedUsersCubit>(
      create: (_) => FollowingCubit(userId: userId),
      child: const PaginatedUsersScreen(
        title: 'following',
        errorMessage: 'error loading following users',
        noDataMessage: 'no following users exist',
      ),
    );
  }
}
