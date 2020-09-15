import 'package:flutter/material.dart';
import 'package:harpy/components/user/widgets/user_card.dart';
import 'package:harpy/core/api/twitter/user_data.dart';

/// Builds a [CustomScrollView] for the [users].
///
/// An optional list of [endSlivers] are built after the [users].
class UserList extends StatelessWidget {
  const UserList(
    this.users, {
    this.endSlivers = const <Widget>[],
    this.enableScroll = true,
  });

  final List<UserData> users;

  /// Slivers built at the end of the [CustomScrollView].
  final List<Widget> endSlivers;

  /// Whether the user list should be scrollable.
  final bool enableScroll;

  Widget _itemBuilder(BuildContext context, int index) {
    final int itemIndex = index ~/ 2;

    if (index.isEven) {
      return UserCard(users[itemIndex]);
    } else {
      return const SizedBox(height: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: enableScroll
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(8),
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
