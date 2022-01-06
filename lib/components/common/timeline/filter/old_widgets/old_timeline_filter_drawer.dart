import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class OldTimelineFilterDrawer extends StatelessWidget {
  const OldTimelineFilterDrawer({
    required this.title,
    required this.onFilter,
    required this.onClear,
    required this.showFilterButton,
  });

  final String title;
  final VoidCallback onFilter;
  final VoidCallback onClear;
  final bool showFilterButton;

  Widget _buildIncludesGroup(TimelineFilterModel model) {
    return FilterGroup(
      title: 'includes',
      toggleAll: model.toggleIncludes,
      allToggled: model.toggledAllIncludes,
      children: [
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
      children: [
        FilterListEntry(
          labelText: 'keyword / phrase',
          activeFilters: model.value.excludesPhrases,
          onSubmitted: model.addExcludingPhrase,
          onDeleted: model.removeExcludingPhrase,
        ),
        verticalSpacer,
        FilterListEntry(
          labelText: 'hashtag',
          activeFilters: model.value.excludesHashtags,
          onSubmitted: model.addExcludingHashtag,
          onDeleted: model.removeExcludingHashtag,
        ),
        verticalSpacer,
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
    final model = context.watch<TimelineFilterModel>();

    return FilterDrawer(
      title: title,
      showClear: model.hasFilter,
      showSearchButton: showFilterButton,
      searchButtonText: model.hasFilter ? 'apply filter' : 'clear filter',
      searchButtonIcon: Icons.filter_alt_rounded,
      onClear: () async {
        await Navigator.of(context).maybePop();
        model.clear();
        onClear();
      },
      onSearch: onFilter,
      filterGroups: [
        _buildIncludesGroup(model),
        _buildExcludesGroup(model),
      ],
    );
  }
}
