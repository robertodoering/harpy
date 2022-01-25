import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class TweetSearchFilterDrawer extends StatelessWidget {
  const TweetSearchFilterDrawer();

  Widget _buildGeneralGroup(
    Config config,
    TweetSearchFilterModel model,
    ThemeData theme,
  ) {
    final style = theme.textTheme.subtitle1!.copyWith(fontSize: 14);

    return ExpansionCard(
      title: const Text('general'),
      children: [
        Padding(
          padding: config.edgeInsetsSymmetric(horizontal: true),
          child: ClearableTextField(
            text: model.value.tweetAuthor,
            removeFocusOnClear: true,
            decoration: const InputDecoration(
              labelText: 'tweet author',
              labelStyle: TextStyle(fontSize: 14),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: kBorderRadius,
              ),
            ),
            onChanged: model.setTweetAuthor,
          ),
        ),
        verticalSpacer,
        Padding(
          padding: config.edgeInsetsSymmetric(horizontal: true),
          child: ClearableTextField(
            text: model.value.replyingTo,
            removeFocusOnClear: true,
            decoration: const InputDecoration(
              labelText: 'replying to',
              labelStyle: TextStyle(fontSize: 14),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: kBorderRadius,
              ),
            ),
            onChanged: model.setReplyingTo,
          ),
        ),
        verticalSpacer,
        ListTile(
          title: Text('results', style: style),
          trailing: DropdownButton<int>(
            value: model.value.resultType,
            onChanged: model.setResultType,
            items: [
              DropdownMenuItem<int>(
                value: 0,
                child: Text('mixed (default)', style: style),
              ),
              DropdownMenuItem<int>(
                value: 1,
                child: Text('recent', style: style),
              ),
              DropdownMenuItem<int>(
                value: 2,
                child: Text('popular', style: style),
              ),
            ],
          ),
        ),
        verticalSpacer,
      ],
    );
  }

  Widget _buildIncludesGroup(TweetSearchFilterModel model) {
    return ExpansionCard(
      title: const Text('includes'),
      children: [
        FilterListEntry(
          labelText: 'keyword / phrase',
          activeFilters: model.value.includesPhrases,
          onSubmitted: model.addIncludingPhrase,
          onDeleted: model.removeIncludingPhrase,
        ),
        verticalSpacer,
        FilterListEntry(
          labelText: 'hashtag',
          activeFilters: model.value.includesHashtags,
          onSubmitted: model.addIncludingHashtag,
          onDeleted: model.removeIncludingHashtag,
        ),
        verticalSpacer,
        FilterListEntry(
          labelText: 'user mention',
          activeFilters: model.value.includesMentions,
          onSubmitted: model.addIncludingMention,
          onDeleted: model.removeIncludingMention,
        ),
        verticalSpacer,
        FilterListEntry(
          labelText: 'url',
          activeFilters: model.value.includesUrls,
          onSubmitted: model.addIncludingUrl,
          onDeleted: model.removeIncludingUrls,
        ),
        verticalSpacer,
        FilterSwitchTile(
          text: 'retweets',
          enabled: model.enableIncludesRetweets,
          value: model.value.includesRetweets,
          onChanged: model.setIncludesRetweets,
        ),
        FilterSwitchTile(
          text: 'images',
          enabled: model.enableIncludesImages,
          value: model.value.includesImages,
          onChanged: model.setIncludesImages,
        ),
        FilterSwitchTile(
          text: 'video',
          enabled: model.enableIncludesVideos,
          value: model.value.includesVideo,
          onChanged: model.setIncludesVideo,
        ),
      ],
    );
  }

  Widget _buildExcludesGroup(TweetSearchFilterModel model) {
    return ExpansionCard(
      title: const Text('excludes'),
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
        FilterListEntry(
          labelText: 'user mention',
          activeFilters: model.value.excludesMentions,
          onSubmitted: model.addExcludingMention,
          onDeleted: model.removeExcludingMention,
        ),
        verticalSpacer,
        FilterSwitchTile(
          text: 'retweets',
          enabled: model.enableExcludesRetweets,
          value: model.value.excludesRetweets,
          onChanged: model.setExcludesRetweets,
        ),
        FilterSwitchTile(
          text: 'images',
          enabled: model.enableExcludesImages,
          value: model.value.excludesImages,
          onChanged: model.setExcludesImages,
        ),
        FilterSwitchTile(
          text: 'video',
          enabled: model.enableExcludesVideos,
          value: model.value.excludesVideo,
          onChanged: model.setExcludesVideo,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<TweetSearchCubit>();
    final model = context.watch<TweetSearchFilterModel>();

    return FilterDrawer(
      title: 'advanced filter',
      showClear: model.hasFilter,
      showSearchButton: model.hasSearchQuery,
      onClear: model.clear,
      onSearch: () => cubit.search(filter: model.value),
      filterGroups: [
        _buildGeneralGroup(config, model, theme),
        _buildIncludesGroup(model),
        _buildExcludesGroup(model),
      ],
    );
  }
}
