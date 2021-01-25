import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/filter/filter_check_box.dart';
import 'package:harpy/components/common/filter/filter_group.dart';
import 'package:harpy/components/common/filter/filter_list_entry.dart';
import 'package:harpy/components/common/misc/clearable_text_field.dart';
import 'package:harpy/components/common/misc/harpy_background.dart';
import 'package:harpy/components/search/tweet/filter/model/tweet_search_filter_model.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

class TweetSearchFilterDrawer extends StatelessWidget {
  const TweetSearchFilterDrawer();

  Widget _buildGeneralGroup(TweetSearchFilterModel model) {
    return FilterGroup(
      title: 'general',
      children: <Widget>[
        Padding(
          padding: DefaultEdgeInsets.symmetric(horizontal: true),
          child: ClearableTextField(
            removeFocusOnClear: true,
            decoration: const InputDecoration(
              labelText: 'tweet author',
              labelStyle: TextStyle(fontSize: 14),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: kDefaultBorderRadius,
              ),
            ),
            onChanged: model.setTweetAuthor,
          ),
        ),
        defaultVerticalSpacer,
        Padding(
          padding: DefaultEdgeInsets.symmetric(horizontal: true),
          child: ClearableTextField(
            removeFocusOnClear: true,
            decoration: const InputDecoration(
              labelText: 'replying to',
              labelStyle: TextStyle(fontSize: 14),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: kDefaultBorderRadius,
              ),
            ),
            onChanged: model.setTweetAuthor,
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
        FilterCheckBox(
          text: 'retweets',
          enabled: model.enableIncludesRetweets,
          value: model.value.includesRetweets,
          onChanged: model.setIncludesRetweets,
        ),
        FilterCheckBox(
          text: 'images',
          enabled: model.enableIncludesImages,
          value: model.value.includesImages,
          onChanged: model.setIncludesImages,
        ),
        FilterCheckBox(
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
        FilterCheckBox(
          text: 'retweets',
          enabled: model.enableExcludesRetweets,
          value: model.value.excludesRetweets,
          onChanged: model.setExcludesRetweets,
        ),
        FilterCheckBox(
          text: 'images',
          enabled: model.enableExcludesImages,
          value: model.value.excludesImages,
          onChanged: model.setExcludesImages,
        ),
        FilterCheckBox(
          text: 'video',
          enabled: model.enableExcludesVideos,
          value: model.value.excludesVideo,
          onChanged: model.setExcludesVideo,
        ),
      ],
    );
  }

  Widget _buildList(
    MediaQueryData mediaQuery,
    ThemeData theme,
    TweetSearchFilterModel model,
  ) {
    return ListView(
      primary: false,
      padding: EdgeInsets.zero,
      children: <Widget>[
        // add status bar height to top padding and make it scrollable
        SizedBox(height: defaultPaddingValue + mediaQuery.padding.top),
        Text('advanced filter', style: theme.textTheme.subtitle1),
        defaultVerticalSpacer,
        _buildGeneralGroup(model),
        defaultVerticalSpacer,
        _buildIncludesGroup(model),
        defaultVerticalSpacer,
        _buildExcludesGroup(model),
        // add nav bar height to bottom padding and make it scrollable
        SizedBox(height: defaultPaddingValue + mediaQuery.padding.bottom),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final TweetSearchFilterModel model =
        context.watch<TweetSearchFilterModel>();

    return Drawer(
      child: HarpyBackground(
        child: Padding(
          padding: DefaultEdgeInsets.symmetric(horizontal: true),
          child: _buildList(mediaQuery, theme, model),
        ),
      ),
    );
  }
}
