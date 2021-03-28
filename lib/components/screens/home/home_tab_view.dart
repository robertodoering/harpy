import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView();

  @override
  Widget build(BuildContext context) {
    return ScrollDirectionListener(
      child: HarpySliverTabView(
        headerSlivers: const <Widget>[
          HomeAppBar(),
        ],
        tabs: const <Widget>[
          HarpyTab(icon: Icon(CupertinoIcons.home)),
          HarpyTab(icon: Icon(CupertinoIcons.photo)),
          HarpyTab(icon: Text('@')),
          HarpyTab(icon: Icon(CupertinoIcons.search)),
        ],
        children: const <Widget>[
          HomeTimeline(),
          HomeMediaTimeline(),
          MentionsTimeline(),
          SearchScreen(),
        ],
      ),
    );
  }
}
