import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      // todo: create custom nested scroll view with sliver stack from
      //  sliver_tools to build the header slivers on top of the body
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, __) => const <Widget>[
          HomeAppBar(
            bottom: HomeTabBar(),
          ),
        ],
        body: const TabBarView(
          children: <Widget>[
            HomeTimeline(),
            HomeMediaTimeline(),
            MentionsTimeline(),
            SearchScreen(),
          ],
        ),
      ),
    );
  }
}
