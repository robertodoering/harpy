import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView();

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
        body: const TabBarView(
          children: <Widget>[
            HomeTimeline(),
            HomeMediaTimeline(),
            MentionsTimeline(indexInTabView: 2),
            SearchScreen(),
          ],
        ),
      ),
    );
  }
}