import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class TweetSearchFilter extends ConsumerWidget {
  const TweetSearchFilter({
    required this.initialFilter,
    required this.onSaved,
  });

  final TweetSearchFilterData? initialFilter;
  final ValueChanged<TweetSearchFilterData>? onSaved;

  static const name = 'tweet_search_filter';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final filter = ref.watch(tweetSearchFilterProvider(initialFilter));
    final notifier = ref.watch(
      tweetSearchFilterProvider(initialFilter).notifier,
    );

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          HarpySliverAppBar(
            title: const Text('advanced query'),
            actions: [
              HarpyButton.icon(
                icon: const Icon(CupertinoIcons.search),
                onTap: filter.isValid
                    ? () {
                        HapticFeedback.lightImpact();
                        onSaved?.call(
                          ref.read(tweetSearchFilterProvider(initialFilter)),
                        );
                        Navigator.of(context).pop();
                      }
                    : null,
              ),
            ],
          ),
          SliverPadding(
            padding: display.edgeInsets,
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                _InvalidFilterInfo(filter: filter),
                _FilterGeneralGroup(filter: filter, notifier: notifier),
                verticalSpacer,
                _FilterIncludesGroup(filter: filter, notifier: notifier),
                verticalSpacer,
                _FilterExcludesGroup(filter: filter, notifier: notifier),
              ]),
            ),
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _InvalidFilterInfo extends ConsumerWidget {
  const _InvalidFilterInfo({
    required this.filter,
  });

  final TweetSearchFilterData filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return AnimatedSize(
      duration: kShortAnimationDuration,
      curve: Curves.easeOutCubic,
      child: HarpyAnimatedSwitcher(
        child: !filter.isEmpty() && !filter.isValid
            ? Padding(
                padding: display.edgeInsets.copyWith(top: 0),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.info, color: theme.colorScheme.primary),
                    horizontalSpacer,
                    Expanded(
                      child: Text(
                        'a general / included search query is required',
                        style: theme.textTheme.titleSmall!.apply(
                          fontSizeDelta: -2,
                          color: theme.colorScheme.onBackground.withOpacity(.7),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox(width: double.infinity),
      ),
    );
  }
}

class _FilterGeneralGroup extends ConsumerWidget {
  const _FilterGeneralGroup({
    required this.filter,
    required this.notifier,
  });

  final TweetSearchFilterData filter;
  final TweetSearchFilterNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final harpyTheme = ref.watch(harpyThemeProvider);

    return ExpansionCard(
      title: const Text('general'),
      children: [
        smallVerticalSpacer,
        Padding(
          padding: display.edgeInsetsSymmetric(horizontal: true),
          child: ClearableTextField(
            text: filter.tweetAuthor,
            decoration: const InputDecoration(
              labelText: 'tweet author',
              isDense: true,
            ),
            onChanged: notifier.setTweetAuthor,
            onClear: () => notifier.setTweetAuthor(''),
          ),
        ),
        verticalSpacer,
        Padding(
          padding: display.edgeInsetsSymmetric(horizontal: true),
          child: ClearableTextField(
            text: filter.replyingTo,
            decoration: const InputDecoration(
              labelText: 'replying to',
              isDense: true,
            ),
            onChanged: notifier.setReplyingTo,
            onClear: () => notifier.setReplyingTo(''),
          ),
        ),
        verticalSpacer,
        HarpyListTile(
          title: const Text('results'),
          trailing: DropdownButton<TweetSearchResultType>(
            borderRadius: harpyTheme.borderRadius,
            value: filter.resultType,
            isDense: true,
            icon: const Icon(Icons.arrow_drop_down_rounded),
            onChanged: (value) =>
                value != null ? notifier.setResultType(value) : null,
            items: const [
              DropdownMenuItem(
                value: TweetSearchResultType.mixed,
                child: Text('mixed (default)'),
              ),
              DropdownMenuItem(
                value: TweetSearchResultType.popular,
                child: Text('popular'),
              ),
              DropdownMenuItem(
                value: TweetSearchResultType.recent,
                child: Text('recent'),
              ),
            ],
          ),
        ),
        verticalSpacer,
      ],
    );
  }
}

class _FilterIncludesGroup extends ConsumerWidget {
  const _FilterIncludesGroup({
    required this.filter,
    required this.notifier,
  });

  final TweetSearchFilterData filter;
  final TweetSearchFilterNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionCard(
      title: const Text('includes'),
      children: [
        smallVerticalSpacer,
        FilterListEntry(
          labelText: 'keyword / phrase',
          activeFilters: filter.includesPhrases,
          onSubmitted: notifier.addIncludingPhrase,
          onDeleted: notifier.removeIncludingPhrase,
        ),
        verticalSpacer,
        FilterListEntry(
          labelText: 'hashtag',
          activeFilters: filter.includesHashtags,
          onSubmitted: notifier.addIncludingHashtag,
          onDeleted: notifier.removeIncludingHashtag,
        ),
        verticalSpacer,
        FilterListEntry(
          labelText: 'user mention',
          activeFilters: filter.includesMentions,
          onSubmitted: notifier.addIncludingMention,
          onDeleted: notifier.removeIncludingMention,
        ),
        verticalSpacer,
        FilterListEntry(
          labelText: 'url',
          activeFilters: filter.includesUrls,
          onSubmitted: notifier.addIncludingUrl,
          onDeleted: notifier.removeIncludingUrls,
        ),
        verticalSpacer,
        FilterSwitchTile(
          text: 'retweets',
          value: filter.includesRetweets,
          enabled: !filter.excludesRetweets,
          onChanged: notifier.setIncludesRetweets,
        ),
        FilterSwitchTile(
          text: 'images',
          value: filter.includesImages,
          enabled: !filter.excludesImages,
          onChanged: notifier.setIncludesImages,
        ),
        FilterSwitchTile(
          text: 'video',
          value: filter.includesVideo,
          enabled: !filter.excludesVideo,
          onChanged: notifier.setIncludesVideo,
        ),
      ],
    );
  }
}

class _FilterExcludesGroup extends ConsumerWidget {
  const _FilterExcludesGroup({
    required this.filter,
    required this.notifier,
  });

  final TweetSearchFilterData filter;
  final TweetSearchFilterNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionCard(
      title: const Text('excludes'),
      children: [
        smallVerticalSpacer,
        FilterListEntry(
          labelText: 'keyword / phrase',
          activeFilters: filter.excludesPhrases,
          onSubmitted: notifier.addExcludingPhrase,
          onDeleted: notifier.removeExcludingPhrase,
        ),
        verticalSpacer,
        FilterListEntry(
          labelText: 'hashtag',
          activeFilters: filter.excludesHashtags,
          onSubmitted: notifier.addExcludingHashtag,
          onDeleted: notifier.removeExcludingHashtag,
        ),
        verticalSpacer,
        FilterListEntry(
          labelText: 'user mention',
          activeFilters: filter.excludesMentions,
          onSubmitted: notifier.addExcludingMention,
          onDeleted: notifier.removeExcludingMention,
        ),
        verticalSpacer,
        FilterSwitchTile(
          text: 'retweets',
          value: filter.excludesRetweets,
          enabled: !filter.includesRetweets,
          onChanged: notifier.setExcludesRetweets,
        ),
        FilterSwitchTile(
          text: 'images',
          value: filter.excludesImages,
          enabled: !filter.includesImages,
          onChanged: notifier.setExcludesImages,
        ),
        FilterSwitchTile(
          text: 'video',
          value: filter.excludesVideo,
          enabled: !filter.includesVideo,
          onChanged: notifier.setExcludesVideo,
        ),
      ],
    );
  }
}
