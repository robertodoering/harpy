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

class SearchPageContent extends ConsumerStatefulWidget {
  const SearchPageContent({
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
    this.scrollPosition = 0,
  });

  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;
  final int scrollPosition;

  @override
  ConsumerState<SearchPageContent> createState() => _SearchPageContentState();
}

class _SearchPageContentState extends ConsumerState<SearchPageContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final display = ref.watch(displayPreferencesProvider);

    return ScrollToTop(
      scrollPosition: widget.scrollPosition,
      child: CustomScrollView(
        slivers: [
          ...widget.beginSlivers,
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
          ...widget.endSlivers,
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
