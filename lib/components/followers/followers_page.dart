import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class FollowersPage extends ConsumerWidget {
  const FollowersPage({
    required this.userId,
  });

  final String userId;

  static const name = 'followers';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginatedUsersPage(
      provider: followersProvider(userId),
      title: 'followers',
      errorMessage: 'error loading followers',
      noDataMessage: 'no followers exist',
    );
  }
}
