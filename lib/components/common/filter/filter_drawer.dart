import 'package:flutter/material.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({
    @required this.title,
    @required this.filterGroups,
    @required this.showSearchButton,
    @required this.onSearch,
  });

  final String title;
  final List<Widget> filterGroups;
  final bool showSearchButton;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
