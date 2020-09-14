import 'package:flutter/material.dart';
import 'package:harpy/components/following_followers/common/widgets/following_followers_screen.dart';
import 'package:harpy/components/following_followers/following/bloc/following_bloc.dart';
import 'package:harpy/components/following_followers/following/bloc/following_event.dart';

/// Builds the screen with a list of the following users for the user with the
/// [userId].
class FollowingScreen extends StatelessWidget {
  const FollowingScreen({
    @required this.userId,
  });

  /// The [userId] of the user whom to search the following users for.
  final String userId;

  static const String route = 'following';

  @override
  Widget build(BuildContext context) {
    return FollowingFollowersScreen<FollowingBloc>(
      create: (BuildContext context) => FollowingBloc(userId: userId),
      userId: userId,
      title: 'Following',
      errorMessage: 'Error loading following users',
      loadUsers: (FollowingBloc bloc) => bloc.add(const LoadFollowingUsers()),
    );
  }
}
