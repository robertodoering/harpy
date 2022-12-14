import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class LegacyUserConnectionsCount extends StatelessWidget {
  const LegacyUserConnectionsCount({
    required this.user,
    this.compact = false,
  });

  final UserData user;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      children: [
        ConnectionCount(
          count: user.followingCount,
          builder: (count) => RbyButton.transparent(
            label: Text('$count following'),
            padding: compact
                ? EdgeInsets.symmetric(
                    horizontal: theme.spacing.base,
                    vertical: theme.spacing.small,
                  )
                : null,
            onTap: () => context.pushNamed(
              FollowingPage.name,
              params: {'handle': user.handle},
            ),
          ),
        ),
        ConnectionCount(
          count: user.followersCount,
          builder: (count) => RbyButton.transparent(
            label: Text('$count followers'),
            padding: compact
                ? EdgeInsets.symmetric(
                    horizontal: theme.spacing.base,
                    vertical: theme.spacing.small,
                  )
                : null,
            onTap: () => context.pushNamed(
              FollowersPage.name,
              params: {'handle': user.handle},
            ),
          ),
        ),
      ],
    );
  }
}
