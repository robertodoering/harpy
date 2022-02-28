import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage();

  static const name = 'search';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const HarpyScaffold(
      child: ScrollDirectionListener(
        child: SearchPageContent(
          beginSlivers: [HarpySliverAppBar(title: 'search')],
        ),
      ),
    );
  }
}

class SearchPageContent extends ConsumerStatefulWidget {
  const SearchPageContent({
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
  });

  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;

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
    return HarpyListCard(
      leading: const Icon(CupertinoIcons.search),
      title: const Text('users'),
      onTap: () {}, // TODO: navigate to user search
      // onTap: () => app<HarpyNavigator>().pushNamed(UserSearchScreen.route),
    );
  }
}

class _TweetSearchCard extends ConsumerWidget {
  const _TweetSearchCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HarpyListCard(
      leading: const Icon(CupertinoIcons.search),
      title: const Text('tweets'),
      onTap: () {}, // TODO: navigate to tweet search
      // onTap: () => app<HarpyNavigator>().pushTweetSearchScreen(),
    );
  }
}
