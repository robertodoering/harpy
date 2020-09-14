import 'package:flutter/material.dart';
import 'package:harpy/components/following_followers/common/widgets/following_followers_screen.dart';
import 'package:harpy/components/following_followers/followers/bloc/followers_bloc.dart';
import 'package:harpy/components/following_followers/followers/bloc/followers_event.dart';

/// Builds the screen with a list of the followers for the user with the
/// [userId].
class FollowersScreen extends StatelessWidget {
  const FollowersScreen({
    @required this.userId,
  });

  /// The [userId] of the user whom to search the followers for.
  final String userId;

  static const String route = 'followers';

  @override
  Widget build(BuildContext context) {
    return FollowingFollowersScreen<FollowersBloc>(
      create: (BuildContext context) => FollowersBloc(userId: userId),
      userId: userId,
      title: 'Followers',
      errorMessage: 'Error loading followers',
      loadUsers: (FollowersBloc bloc) => bloc.add(const LoadFollowers()),
    );
  }
}
