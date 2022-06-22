import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage();

  static const name = 'search';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const HarpyScaffold(
      child: ScrollDirectionListener(
        child: SearchPageContent(
          beginSlivers: [HarpySliverAppBar(title: Text('search'))],
        ),
      ),
    );
  }
}

class SearchPageContent extends ConsumerWidget {
  const SearchPageContent({
    this.scrollToTopOffset,
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
  });

  final double? scrollToTopOffset;
  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return ScrollToTop(
      bottomPadding: scrollToTopOffset,
      child: CustomScrollView(
        slivers: [
          ...beginSlivers,
          SliverPadding(
            padding: display.edgeInsets.copyWith(bottom: 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(const [
                _UserSearchCard(),
                verticalSpacer,
                _TweetSearchCard(),
              ]),
            ),
          ),
          SliverToBoxAdapter(child: Divider(height: display.paddingValue * 2)),
          const TrendsSelectionHeader(),
          sliverVerticalSpacer,
          const TrendsList(),
          ...endSlivers,
        ],
      ),
    );
  }
}

class _UserSearchCard extends ConsumerWidget {
  const _UserSearchCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return HarpyListCard(
      leading: const Icon(CupertinoIcons.search),
      title: const Text('users'),
      onTap: () => router.pushNamed(UserSearchPage.name),
    );
  }
}

class _TweetSearchCard extends ConsumerWidget {
  const _TweetSearchCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);

    return HarpyListCard(
      leading: const Icon(CupertinoIcons.search),
      title: const Text('tweets'),
      onTap: () => router.pushNamed(TweetSearchPage.name),
    );
  }
}
