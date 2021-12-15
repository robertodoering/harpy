import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/likes_retweets/sort/models/user_sort_by_model.dart';
import 'package:provider/provider.dart';

class UserListSortDrawer extends StatelessWidget {
  const UserListSortDrawer({
    required this.title,
    required this.onSort,
    required this.onClear,
    required this.showSortButton,
  });

  final String title;
  final VoidCallback onSort;
  final VoidCallback onClear;
  final bool showSortButton;

  Widget _buildSortOptions(UserListSortByModel model) {
    return FilterGroup(
      title: 'Sort Options',
      allToggled: false,
      children: [
        FilterSwitchTile(
          text: 'Display Name A-Z',
          value: model.value.displayName,
          onChanged: model.setByDisplayName,
        ),
        FilterSwitchTile(
          text: 'Handle A-Z',
          value: model.value.handle,
          onChanged: model.setByHandle,
        ),
        FilterSwitchTile(
          text: 'most followers',
          value: model.value.followers,
          onChanged: model.setByFollowers,
        ),
        FilterSwitchTile(
          text: 'most following',
          value: model.value.following,
          onChanged: model.setByFollowing,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserListSortByModel>();

    return FilterDrawer(
      title: title,
      showClear: model.hasSort,
      showSearchButton: showSortButton,
      searchButtonText: model.hasSort ? 'apply sort' : 'set to default',
      searchButtonIcon: Icons.sort_outlined,
      onClear: () async {
        await Navigator.of(context).maybePop();
        model.clear();
        onClear();
      },
      onSearch: onSort,
      filterGroups: [
        _buildSortOptions(model),
      ],
    );
  }
}
