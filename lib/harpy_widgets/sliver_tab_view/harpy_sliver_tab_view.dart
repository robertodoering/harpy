import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// A sliver page view that displays the widget which corresponds to the
/// currently selected [HarpyTab].
class HarpySliverTabView extends StatelessWidget {
  const HarpySliverTabView({
    @required this.tabs,
    @required this.children,
    this.endTab,
    this.headerSlivers,
  }) : assert(tabs.length == children.length);

  final List<Widget> tabs;
  final Widget endTab;
  final List<Widget> children;
  final List<Widget> headerSlivers;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: children.length,
      child: NestedScrollView(
        headerSliverBuilder: (_, __) => <Widget>[
          ...?headerSlivers,
          HarpySliverTapBar(
            tabs: tabs,
            endTab: endTab,
          ),
        ],
        body: TabBarView(
          children: children,
        ),
      ),
    );
  }
}
