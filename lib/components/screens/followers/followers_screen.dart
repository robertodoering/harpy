import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

/// Builds the screen with a list of the followers for the specified user.
class FollowersScreen extends StatelessWidget {
  const FollowersScreen({
    required this.userId,
  });

  /// The [userId] of the user whom to search the followers for.
  final String userId;

  static const route = 'followers';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaginatedUsersCubit>(
      create: (_) => FollowersCubit(userId: userId),
      child: const PaginatedUsersScreen(
        title: 'followers',
        errorMessage: 'error loading followers',
        noDataMessage: 'no followers exist',
      ),
    );
  }
}
