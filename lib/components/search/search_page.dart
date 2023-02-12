import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

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

class SearchPageContent extends StatelessWidget {
  const SearchPageContent({
    this.scrollToTopOffset,
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
  });

  final double? scrollToTopOffset;
  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScrollToTop(
      bottomPadding: scrollToTopOffset,
      child: CustomScrollView(
        slivers: [
          ...beginSlivers,
          SliverPadding(
            padding: theme.spacing.edgeInsets.copyWith(bottom: 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(const [
                _UserSearchCard(),
                VerticalSpacer.normal,
                _TweetSearchCard(),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(
              height: theme.spacing.base * 2,
              color: theme.dividerColor,
            ),
          ),
          const TrendsSelectionHeader(),
          VerticalSpacer.normalSliver,
          const TrendsList(),
          ...endSlivers,
        ],
      ),
    );
  }
}

class _UserSearchCard extends StatelessWidget {
  const _UserSearchCard();

  @override
  Widget build(BuildContext context) {
    return RbyListCard(
      leading: const Icon(CupertinoIcons.search),
      title: const Text('users'),
      onTap: () => context.pushNamed(UserSearchPage.name),
    );
  }
}

class _TweetSearchCard extends StatelessWidget {
  const _TweetSearchCard();

  @override
  Widget build(BuildContext context) {
    return RbyListCard(
      leading: const Icon(CupertinoIcons.search),
      title: const Text('tweets'),
      onTap: () => context.pushNamed(TweetSearchPage.name),
    );
  }
}
