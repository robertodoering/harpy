import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:intl/intl.dart';

class UserFollowersCount extends ConsumerWidget {
  const UserFollowersCount({
    required this.user,
  });

  final UserData user;

  static final _numberFormat = NumberFormat.compact();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final router = ref.watch(routerProvider);

    final friendsCount = _numberFormat.format(user.friendsCount);
    final followersCount = _numberFormat.format(user.followersCount);

    return Wrap(
      spacing: display.paddingValue,
      runSpacing: display.smallPaddingValue,
      alignment: WrapAlignment.spaceBetween,
      children: [
        Tooltip(
          message: '${user.friendsCount}',
          child: HarpyButton.text(
            label: Text('$friendsCount following'),
            onTap: () => router.goNamed(
              FollowingPage.name,
              params: {'id': user.id},
            ),
          ),
        ),
        Tooltip(
          message: '${user.followersCount}',
          child: HarpyButton.text(
            label: Text('$followersCount followers'),
            onTap: () => router.goNamed(
              FollowersPage.name,
              params: {'id': user.id},
            ),
          ),
        ),
      ],
    );
  }
}
