import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/screens/likes_retweets/sort/models/like_sort_by_model.dart';
import 'package:provider/provider.dart';

class UserListSortDrawer extends StatelessWidget {
  const UserListSortDrawer({
    required this.title,
    required this.onFilter,
    required this.onClear,
    required this.showFilterButton,
  });

  final String title;
  final VoidCallback onFilter;
  final VoidCallback onClear;
  final bool showFilterButton;

  Widget _buildSortOptions(UserListSortByModel model) {
    return FilterGroup(
      title: 'Sort Options',
      allToggled: false,
      children: [
        FilterSwitchTile(
          text: 'byDisplayName',
          value: model.value.byDisplayName,
          onChanged: model.setByDisplayName,
        ),
        FilterSwitchTile(
          text: 'byHandle',
          value: model.value.byHandle,
          onChanged: model.setByHandle,
        ),
        FilterSwitchTile(
          text: 'byFollowers',
          value: model.value.byFollowers,
          onChanged: model.setByFollowers,
        ),
        FilterSwitchTile(
          text: 'byFollowing',
          value: model.value.byFollowing,
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
      showSearchButton: showFilterButton,
      searchButtonText: model.hasSort ? 'apply sort' : 'set to default',
      searchButtonIcon: Icons.filter_alt_rounded,
      onClear: () async {
        await Navigator.of(context).maybePop();
        model.clear();
        onClear();
      },
      onSearch: onFilter,
      filterGroups: [
        _buildSortOptions(model),
      ],
    );
  }
}
