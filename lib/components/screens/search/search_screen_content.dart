import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class SearchScreenContent extends StatelessWidget {
  const SearchScreenContent({
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
  });

  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;

  Widget _buildUserSearchCard() {
    return HarpyListCard(
      leading: const Icon(CupertinoIcons.search),
      title: const Text('users'),
      onTap: () => app<HarpyNavigator>().pushNamed(UserSearchScreen.route),
    );
  }

  Widget _buildTweetSearchCard() {
    return HarpyListCard(
      leading: const Icon(CupertinoIcons.search),
      title: const Text('tweets'),
      onTap: () => app<HarpyNavigator>().pushTweetSearchScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return ScrollToStart(
      child: CustomScrollView(
        slivers: [
          ...beginSlivers,
          SliverPadding(
            padding: config.edgeInsets.copyWith(bottom: 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildUserSearchCard(),
                verticalSpacer,
                _buildTweetSearchCard(),
              ]),
            ),
          ),
          SliverToBoxAdapter(child: Divider(height: config.paddingValue * 2)),
          const SliverToBoxAdapter(child: TrendsCard()),
          const SliverToBoxAdapter(child: verticalSpacer),
          const TrendsList(),
          ...endSlivers,
        ],
      ),
    );
  }
}
