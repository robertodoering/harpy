import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

// todo: when switching tabs in the home tab view, consider scrolling the
//  content automatically if it is otherwise covered by the tab bar

class HomeTabView extends StatelessWidget {
  // non-const to always rebuild when returning to home screen
  // ignore: prefer_const_constructors_in_immutables
  HomeTabView();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return DefaultTabController(
      length: 5,
      child: Stack(
        children: <Widget>[
          NestedScrollView(
            headerSliverBuilder: (_, __) => <Widget>[
              // padding for the home app bar that is built above the nested
              // scroll view
              SliverToBoxAdapter(
                child: SizedBox(
                  height: HomeAppBar.height(mediaQuery.padding.top - 8),
                ),
              ),
            ],
            body: TabBarView(
              children: <Widget>[
                HomeTimeline(),
                const HomeMediaTimeline(),
                const MentionsTimeline(indexInTabView: 2),
                const SearchScreen(),
                const HomeTabCustomization(),
              ],
            ),
          ),
          const HomeAppBar(),
        ],
      ),
    );
  }
}
