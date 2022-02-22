import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

/// Builds a [CustomScrollView] for the [users].
class UserList extends ConsumerWidget {
  const UserList(
    this.users, {
    this.beginSlivers = const [],
    this.endSlivers = const [],
  });

  final List<UserData> users;

  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;

  Widget _itemBuilder(BuildContext context, int index) {
    if (index.isEven)
      return UserCard(users[index ~/ 2]);
    else
      return verticalSpacer;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return CustomScrollView(
      slivers: [
        ...beginSlivers,
        SliverPadding(
          padding: display.edgeInsets,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              _itemBuilder,
              childCount: users.length * 2 - 1,
              addAutomaticKeepAlives: false,
            ),
          ),
        ),
        ...endSlivers,
      ],
    );
  }
}
