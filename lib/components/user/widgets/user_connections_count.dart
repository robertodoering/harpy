import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:intl/intl.dart';

class UserConnectionsCount extends ConsumerWidget {
  const UserConnectionsCount({
    required this.user,
    this.compact = false,
  });

  final UserData user;
  final bool compact;

  static final _numberFormat = NumberFormat.compact();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final router = ref.watch(routerProvider);

    final friendsCount = _numberFormat.format(user.friendsCount);
    final followersCount = _numberFormat.format(user.followersCount);

    return Wrap(
      children: [
        Tooltip(
          message: '${user.friendsCount}',
          child: HarpyButton.icon(
            label: Text('$friendsCount following'),
            padding: compact
                ? EdgeInsets.symmetric(
                    horizontal: display.paddingValue,
                    vertical: display.smallPaddingValue,
                  )
                : null,
            onTap: () => router.pushNamed(
              FollowingPage.name,
              params: {'id': user.id},
            ),
          ),
        ),
        Tooltip(
          message: '${user.followersCount}',
          child: HarpyButton.icon(
            label: Text('$followersCount followers'),
            padding: compact
                ? EdgeInsets.symmetric(
                    horizontal: display.paddingValue,
                    vertical: display.smallPaddingValue,
                  )
                : null,
            onTap: () => router.pushNamed(
              FollowersPage.name,
              params: {'id': user.id},
            ),
          ),
        ),
      ],
    );
  }
}
