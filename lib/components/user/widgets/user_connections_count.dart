import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class UserConnectionsCount extends ConsumerWidget {
  const UserConnectionsCount({
    required this.user,
    this.compact = false,
  });

  final UserData user;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final router = ref.watch(routerProvider);

    return Wrap(
      children: [
        ConnectionCount(
          count: user.friendsCount,
          builder: (count) => HarpyButton.icon(
            label: Text('$count following'),
            padding: compact
                ? EdgeInsets.symmetric(
                    horizontal: display.paddingValue,
                    vertical: display.smallPaddingValue,
                  )
                : null,
            onTap: () => router.pushNamed(
              FollowingPage.name,
              params: {'handle': user.handle},
            ),
          ),
        ),
        ConnectionCount(
          count: user.followersCount,
          builder: (count) => HarpyButton.icon(
            label: Text('$count followers'),
            padding: compact
                ? EdgeInsets.symmetric(
                    horizontal: display.paddingValue,
                    vertical: display.smallPaddingValue,
                  )
                : null,
            onTap: () => router.pushNamed(
              FollowersPage.name,
              params: {'handle': user.handle},
            ),
          ),
        ),
      ],
    );
  }
}
