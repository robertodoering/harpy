import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class TweetSearchFilterDrawer extends StatelessWidget {
  const TweetSearchFilterDrawer();

  Widget _buildGeneralGroup(TweetSearchFilterModel model, ThemeData theme) {
    final TextStyle style = theme.textTheme.subtitle1!.copyWith(fontSize: 14);

    return FilterGroup(
      title: 'general',
      children: <Widget>[
        Padding(
          padding: DefaultEdgeInsets.symmetric(horizontal: true),
          child: ClearableTextField(
            text: model.value.tweetAuthor,
            removeFocusOnClear: true,
            decoration: const InputDecoration(
              labelText: 'tweet author',
              labelStyle: TextStyle(fontSize: 14),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: kDefaultBorderRadius as BorderRadius,
              ),
            ),
            onChanged: model.setTweetAuthor,
          ),
        ),
        defaultVerticalSpacer,
        Padding(
          padding: DefaultEdgeInsets.symmetric(horizontal: true),
          child: ClearableTextField(
            text: model.value.replyingTo,
            removeFocusOnClear: true,
            decoration: const InputDecoration(
              labelText: 'replying to',
              labelStyle: TextStyle(fontSize: 14),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: kDefaultBorderRadius as BorderRadius,
              ),
            ),
            onChanged: model.setReplyingTo,
          ),
        ),
        defaultVerticalSpacer,
        ListTile(
          title: Text('results', style: style),
          trailing: DropdownButton<int>(
            value: model.value.resultType,
            onChanged: model.setResultType,
            items: <DropdownMenuItem<int>>[
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
        defaultVerticalSpacer,
      ],
    );
  }

  Widget _buildIncludesGroup(TweetSearchFilterModel model) {
    return FilterGroup(
      title: 'includes',
      children: <Widget>[
        FilterListEntry(
          labelText: 'keyword / phrase',
          activeFilters: model.value.includesPhrases,
          onSubmitted: model.addIncludingPhrase,
          onDeleted: model.removeIncludingPhrase,
        ),
        defaultVerticalSpacer,
        FilterListEntry(
          labelText: 'hashtag',
          activeFilters: model.value.includesHashtags,
          onSubmitted: model.addIncludingHashtag,
          onDeleted: model.removeIncludingHashtag,
        ),
        defaultVerticalSpacer,
        FilterListEntry(
          labelText: 'user mention',
          activeFilters: model.value.includesMentions,
          onSubmitted: model.addIncludingMention,
          onDeleted: model.removeIncludingMention,
        ),
        defaultVerticalSpacer,
        FilterListEntry(
          labelText: 'url',
          activeFilters: model.value.includesUrls,
          onSubmitted: model.addIncludingUrl,
          onDeleted: model.removeIncludingUrls,
        ),
        defaultVerticalSpacer,
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
        FilterListEntry(
          labelText: 'user mention',
          activeFilters: model.value.excludesMentions,
          onSubmitted: model.addExcludingMention,
          onDeleted: model.removeExcludingMention,
        ),
        defaultVerticalSpacer,
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
    final ThemeData theme = Theme.of(context);
    final TweetSearchBloc bloc = context.watch<TweetSearchBloc>();
    final TweetSearchFilterModel model =
        context.watch<TweetSearchFilterModel>();

    return FilterDrawer(
      title: 'advanced filter',
      showClear: model.hasFilter,
      showSearchButton: model.hasSearchQuery,
      onClear: model.clear,
      onSearch: () => bloc.add(SearchTweets(filter: model.value)),
      filterGroups: <Widget>[
        _buildGeneralGroup(model, theme),
        _buildIncludesGroup(model),
        _buildExcludesGroup(model),
      ],
    );
  }
}
