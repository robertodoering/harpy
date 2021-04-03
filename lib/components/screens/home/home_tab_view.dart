import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class HomeTabView extends StatelessWidget {
  // non-const to always rebuild when returning to home screen
  // ignore: prefer_const_constructors_in_immutables
  HomeTabView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: NestedScrollView(
        headerSliverBuilder: (_, __) => const <Widget>[
          HomeAppBar(
            bottom: HomeTabBar(),
          ),
        ],
        body: TabBarView(
          children: <Widget>[
            HomeTimeline(),
            const HomeMediaTimeline(),
            const MentionsTimeline(indexInTabView: 2),
            const SearchScreen(),
          ],
        ),
      ),
    );
  }
}
