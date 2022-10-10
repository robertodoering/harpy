import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// Builds a [CustomScrollView] for the [users].
class UserList extends ConsumerWidget {
  const UserList(
    this.users, {
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
  });

  final List<UserData> users;

  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;

  Widget _itemBuilder(BuildContext context, int index) {
    return index.isEven ? UserCard(users[index ~/ 2]) : verticalSpacer;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return CustomScrollView(
      slivers: [
        ...beginSlivers,
        SliverPadding(
          padding: display.edgeInsets,
          sliver: SuperSliverList(
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
