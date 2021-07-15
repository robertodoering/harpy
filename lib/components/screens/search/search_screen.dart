import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen();

  Widget _buildUserSearchCard() {
    return Card(
      child: ListTile(
        shape: kDefaultShapeBorder,
        leading: const Icon(CupertinoIcons.search),
        title: const Text('users'),
        onTap: () => app<HarpyNavigator>().pushNamed(UserSearchScreen.route),
      ),
    );
  }

  Widget _buildTweetSearchCard() {
    return Card(
      child: ListTile(
        shape: kDefaultShapeBorder,
        leading: const Icon(CupertinoIcons.search),
        title: const Text('tweets'),
        onTap: () => app<HarpyNavigator>().pushTweetSearchScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return ScrollToStart(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: DefaultEdgeInsets.all().copyWith(bottom: 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildUserSearchCard(),
                  defaultVerticalSpacer,
                  _buildTweetSearchCard(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(height: defaultPaddingValue * 2),
          ),
          const SliverToBoxAdapter(
            child: TrendsCard(),
          ),
          SliverToBoxAdapter(
            child: defaultVerticalSpacer,
          ),
          const TrendsList(),
          SliverToBoxAdapter(
            child: SizedBox(height: mediaQuery.padding.bottom),
          ),
        ],
      ),
    );
  }
}
