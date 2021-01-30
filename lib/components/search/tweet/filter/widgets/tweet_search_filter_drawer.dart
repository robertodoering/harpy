import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/filter/filter_check_box.dart';
import 'package:harpy/components/common/filter/filter_group.dart';
import 'package:harpy/components/common/filter/filter_list_entry.dart';
import 'package:harpy/components/common/misc/clearable_text_field.dart';
import 'package:harpy/components/common/misc/harpy_background.dart';
import 'package:harpy/components/search/tweet/bloc/tweet_search_bloc.dart';
import 'package:harpy/components/search/tweet/filter/model/tweet_search_filter_model.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:harpy/misc/harpy_navigator.dart';

class TweetSearchFilterDrawer extends StatelessWidget {
  const TweetSearchFilterDrawer();

  Widget _buildTitleRow(ThemeData theme, TweetSearchFilterModel model) {
    return Row(
      children: <Widget>[
        defaultHorizontalSpacer,
        Expanded(
          child: Text('advanced filter', style: theme.textTheme.subtitle1),
        ),
        HarpyButton.flat(
          dense: true,
          icon: const Icon(Icons.clear),
          onTap: model.hasFilter ? model.clear : null,
        ),
      ],
    );
  }

  Widget _buildGeneralGroup(TweetSearchFilterModel model, ThemeData theme) {
    final TextStyle style = theme.textTheme.subtitle1.copyWith(fontSize: 14);

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
            text: model.value.replyingTo,
            removeFocusOnClear: true,
            decoration: const InputDecoration(
              labelText: 'replying to',
              labelStyle: TextStyle(fontSize: 14),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: kDefaultBorderRadius,
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

  Widget _buildSearchButton(
    TweetSearchFilterModel model,
    TweetSearchBloc bloc,
    EdgeInsets padding,
  ) {
    return CustomAnimatedSize(
      child: AnimatedSwitcher(
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        duration: kShortAnimationDuration,
        child: model.hasSearchQuery
            ? Padding(
                padding: padding,
                child: SizedBox(
                  width: double.infinity,
                  child: HarpyButton.raised(
                    icon: const Icon(Icons.search),
                    text: const Text('search'),
                    dense: true,
                    onTap: () {
                      bloc.add(SearchTweets(filter: model.value));

                      app<HarpyNavigator>().state.maybePop();
                    },
                  ),
                ),
              )
            : defaultVerticalSpacer,
      ),
    );
  }

  Widget _buildList(
    MediaQueryData mediaQuery,
    ThemeData theme,
    TweetSearchFilterModel model,
    TweetSearchBloc bloc,
  ) {
    return ListView(
      primary: false,
      padding: EdgeInsets.zero,
      children: <Widget>[
        // add status bar height to top padding and make it scrollable
        SizedBox(height: defaultPaddingValue + mediaQuery.padding.top),
        _buildTitleRow(theme, model),
        _buildSearchButton(model, bloc, DefaultEdgeInsets.all()),
        _buildGeneralGroup(model, theme),
        defaultVerticalSpacer,
        _buildIncludesGroup(model),
        defaultVerticalSpacer,
        _buildExcludesGroup(model),
        _buildSearchButton(
          model,
          bloc,
          DefaultEdgeInsets.all().copyWith(bottom: 0),
        ),
        // add nav bar height to bottom padding and make it scrollable
        SizedBox(height: defaultPaddingValue + mediaQuery.padding.bottom),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final TweetSearchBloc bloc = context.watch<TweetSearchBloc>();
    final TweetSearchFilterModel model =
        context.watch<TweetSearchFilterModel>();

    return Drawer(
      child: HarpyBackground(
        child: _buildList(mediaQuery, theme, model, bloc),
      ),
    );
  }
}
