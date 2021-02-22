import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/filter/filter_drawer.dart';
import 'package:harpy/components/common/filter/filter_group.dart';
import 'package:harpy/components/common/filter/filter_list_entry.dart';
import 'package:harpy/components/common/filter/filter_switch_tile.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/timeline/filter/model/timeline_filter_model.dart';
import 'package:provider/provider.dart';

class TimelineFilterDrawer extends StatelessWidget {
  const TimelineFilterDrawer({
    @required this.title,
  });

  final String title;

  Widget _buildIncludesGroup(TimelineFilterModel model) {
    return FilterGroup(
      title: 'includes',
      toggleAll: model.toggleIncludes,
      allToggled: model.toggledAllIncludes,
      children: <Widget>[
        FilterSwitchTile(
          text: 'images',
          value: model.value.includesImages,
          onChanged: model.setIncludesImages,
        ),
        FilterSwitchTile(
          text: 'gif',
          value: model.value.includesGif,
          onChanged: model.setIncludesGif,
        ),
        FilterSwitchTile(
          text: 'video',
          value: model.value.includesVideo,
          onChanged: model.setIncludesVideo,
        ),
      ],
    );
  }

  Widget _buildExcludesGroup(TimelineFilterModel model) {
    return FilterGroup(
      title: 'excludes',
      children: <Widget>[
        FilterListEntry(
          labelText: 'keyword / phrase',
          activeFilters: model.value.excludesPhrases,
          onSubmitted: model.addExcludingPhrase,
          onDeleted: model.removeExcludingPhrase,
        ),
        defaultVerticalSpacer,
        FilterListEntry(
          labelText: 'hashtag',
          activeFilters: model.value.excludesHashtags,
          onSubmitted: model.addExcludingHashtag,
          onDeleted: model.removeExcludingHashtag,
        ),
        defaultVerticalSpacer,
        FilterSwitchTile(
          text: 'replies',
          value: model.value.excludesReplies,
          onChanged: model.setExcludesReplies,
        ),
        FilterSwitchTile(
          text: 'retweets',
          value: model.value.excludesRetweets,
          onChanged: model.setExcludesRetweets,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final TimelineFilterModel model = context.watch<TimelineFilterModel>();

    return FilterDrawer(
      title: title,
      showClear: model.hasFilter,
      showSearchButton: false,
      onClear: model.clear,
      onSearch: () {},
      filterGroups: <Widget>[
        _buildIncludesGroup(model),
        _buildExcludesGroup(model),
      ],
    );
  }
}
