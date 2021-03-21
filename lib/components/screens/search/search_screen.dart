import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen();

  static const String route = 'search_screen';

  Widget _buildUserSearchCard() {
    return Card(
      child: ListTile(
        leading: const Icon(CupertinoIcons.search),
        title: const Text('users'),
        onTap: () async {
          await app<HarpyNavigator>().state.maybePop();
          app<HarpyNavigator>().pushNamed(UserSearchScreen.route);
        },
      ),
    );
  }

  Widget _buildTweetSearchCard() {
    return Card(
      child: ListTile(
        leading: const Icon(CupertinoIcons.search),
        title: const Text('tweets'),
        onTap: () async {
          await app<HarpyNavigator>().state.maybePop();
          app<HarpyNavigator>().pushTweetSearchScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return HarpyScaffold(
      body: ScrollDirectionListener(
        child: ScrollToStart(
          child: CustomScrollView(
            slivers: <Widget>[
              const HarpySliverAppBar(
                title: 'search',
                floating: true,
              ),
              SliverPadding(
                padding: DefaultEdgeInsets.all(),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      _buildUserSearchCard(),
                      defaultVerticalSpacer,
                      _buildTweetSearchCard(),
                      defaultVerticalSpacer,
                      const ListTile(
                        leading: Icon(FeatherIcons.trendingUp, size: 18),
                        title: Text('worldwide trends'),
                      ),
                    ],
                  ),
                ),
              ),
              TrendsList(),
              SliverToBoxAdapter(
                child: SizedBox(height: mediaQuery.padding.bottom),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
