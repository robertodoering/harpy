import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class TweetSearchPage extends ConsumerStatefulWidget {
  const TweetSearchPage({
    this.initialQuery,
  });

  final String? initialQuery;

  static const name = 'tweet_search';

  @override
  ConsumerState<TweetSearchPage> createState() => _TweetSearchPageState();
}

class _TweetSearchPageState extends ConsumerState<TweetSearchPage> {
  @override
  void initState() {
    super.initState();

    if (widget.initialQuery != null) {
      ref
          .read(tweetSearchProvider.notifier)
          .search(customQuery: widget.initialQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);
    final state = ref.watch(tweetSearchProvider);
    final notifier = ref.watch(tweetSearchProvider.notifier);

    return HarpyScaffold(
      child: ScrollDirectionListener(
        child: ScrollToTop(
          child: Builder(
            builder: (context) => RefreshIndicator(
              onRefresh: () async {
                UserScrollDirection.of(context)?.idle();
                await notifier.refresh();
              },
              edgeOffset: HarpySliverAppBar.height(context, ref.read) +
                  display.paddingValue,
              child: TweetList(
                state.tweets.toList(),
                beginSlivers: [
                  SearchAppBar(
                    text: state.query,
                    onSubmitted: (value) => notifier.search(customQuery: value),
                    onClear: notifier.clear,
                    actions: [
                      HarpyButton.icon(
                        icon: state.filter != null
                            ? Icon(
                                Icons.filter_alt,
                                color: theme.colorScheme.primary,
                              )
                            : const Icon(Icons.filter_alt_outlined),
                        onTap: () => _openSearchFilter(
                          context,
                          ref.read,
                          initialFilter: state.filter,
                          notifier: notifier,
                        ),
                      ),
                    ],
                  ),
                  ...?state.mapOrNull(
                    initial: (_) => [
                      SliverFillInfoMessage(
                        primaryMessage: HarpyButton.text(
                          icon: const Icon(Icons.filter_alt_outlined),
                          label: const Text('advanced query'),
                          onTap: () => _openSearchFilter(
                            context,
                            ref.read,
                            initialFilter: state.filter,
                            notifier: notifier,
                          ),
                        ),
                      )
                    ],
                    loading: (_) => const [
                      sliverVerticalSpacer,
                      TweetListLoadingSliver(),
                    ],
                    noData: (_) => const [
                      SliverFillInfoMessage(
                        primaryMessage: Text('no tweets found'),
                        secondaryMessage: Text(
                          'only tweets of the last 7 days can be retrieved',
                        ),
                      ),
                    ],
                    error: (_) => [
                      SliverFillLoadingError(
                        message: const Text('error searching tweets'),
                        onRetry: state.filter != null
                            ? () => notifier.search(filter: state.filter)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _openSearchFilter(
  BuildContext context,
  Reader read, {
  required TweetSearchFilterData? initialFilter,
  required TweetSearchNotifier notifier,
}) {
  FocusScope.of(context).unfocus();

  read(routerProvider).pushNamed(
    TweetSearchFilter.name,
    extra: {
      'initialFilter': initialFilter,
      // ignore: avoid_types_on_closure_parameters
      'onSaved': (TweetSearchFilterData filter) {
        notifier.search(filter: filter);
      },
    },
  );
}
