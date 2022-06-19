import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

// NOTE: "Following users" are also referred to as "friends" in the twitter api.
class FollowingPage extends StatelessWidget {
  const FollowingPage({
    required this.userId,
  });

  final String userId;

  static const name = 'following';

  @override
  Widget build(BuildContext context) {
    return PaginatedUsersPage(
      provider: followingProvider(userId),
      title: 'following',
      errorMessage: 'error loading following users',
      noDataMessage: 'no following users exist',
    );
  }
}
