import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/filter/filter_check_box.dart';
import 'package:harpy/components/common/filter/filter_drawer.dart';
import 'package:harpy/components/common/filter/filter_group.dart';
import 'package:harpy/components/common/filter/filter_list_entry.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

class TimelineFilterDrawer extends StatelessWidget {
  const TimelineFilterDrawer({
    @required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return FilterDrawer(
      title: title,
      filterGroups: <Widget>[
        FilterGroup(
          title: 'includes',
          toggleAll: () {},
          allToggled: false,
          children: <Widget>[
            FilterCheckBox(text: 'images', value: false, onChanged: (_) {}),
            FilterCheckBox(text: 'gif', value: false, onChanged: (_) {}),
            FilterCheckBox(text: 'video', value: false, onChanged: (_) {}),
          ],
        ),
        FilterGroup(
          title: 'excludes',
          children: <Widget>[
            FilterListEntry(
              labelText: 'hashtag',
              activeFilters: [],
              onSubmitted: (String value) {},
              onDeleted: (int value) {},
            ),
            defaultVerticalSpacer,
            FilterListEntry(
              labelText: 'keyword / phrase',
              activeFilters: [],
              onSubmitted: (String value) {},
              onDeleted: (int value) {},
            ),
            defaultVerticalSpacer,
            FilterCheckBox(text: 'replies', value: false, onChanged: (_) {}),
            FilterCheckBox(text: 'retweets', value: false, onChanged: (_) {}),
          ],
        ),
      ],
      onClear: () {},
      onSearch: () {},
      showClear: false,
      showSearchButton: false,
    );
  }
}
