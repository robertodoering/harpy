import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// Builds the screen with a list of the followers for the user with the
/// [userId].
class FollowersScreen extends StatelessWidget {
  const FollowersScreen({
    required this.userId,
  });

  /// The [userId] of the user whom to search the followers for.
  final String? userId;

  static const String route = 'followers';

  @override
  Widget build(BuildContext context) {
    return FollowingFollowersScreen<FollowersBloc>(
      create: (_) => FollowersBloc(userId: userId),
      userId: userId,
      title: 'followers',
      errorMessage: 'error loading followers',
      loadUsers: (bloc) => bloc.add(const LoadFollowers()),
    );
  }
}
