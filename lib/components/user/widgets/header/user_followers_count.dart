import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class UserFollowersCount extends ConsumerWidget {
  const UserFollowersCount({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final router = ref.watch(routerProvider);

    return Wrap(
      spacing: display.paddingValue,
      runSpacing: display.smallPaddingValue,
      alignment: WrapAlignment.spaceBetween,
      children: [
        ConnectionCount(
          count: user.friendsCount,
          builder: (count) => HarpyButton.text(
            label: Text('$count following'),
            onTap: () => router.goNamed(
              FollowingPage.name,
              params: {'handle': user.handle},
            ),
          ),
        ),
        ConnectionCount(
          count: user.followersCount,
          builder: (count) => HarpyButton.text(
            label: Text('$count followers'),
            onTap: () => router.goNamed(
              FollowersPage.name,
              params: {'handle': user.handle},
            ),
          ),
        ),
      ],
    );
  }
}
