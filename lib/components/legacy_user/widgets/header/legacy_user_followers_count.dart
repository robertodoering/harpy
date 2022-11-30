import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class LegacyUserFollowersCount extends StatelessWidget {
  const LegacyUserFollowersCount({
    required this.user,
  });

  final LegacyUserData user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: theme.spacing.base,
      runSpacing: theme.spacing.small,
      alignment: WrapAlignment.spaceBetween,
      children: [
        ConnectionCount(
          count: user.friendsCount,
          builder: (count) => RbyButton.text(
            label: Text('$count following'),
            onTap: () => context.goNamed(
              FollowingPage.name,
              params: {'handle': user.handle},
            ),
          ),
        ),
        ConnectionCount(
          count: user.followersCount,
          builder: (count) => RbyButton.text(
            label: Text('$count followers'),
            onTap: () => context.goNamed(
              FollowersPage.name,
              params: {'handle': user.handle},
            ),
          ),
        ),
      ],
    );
  }
}
