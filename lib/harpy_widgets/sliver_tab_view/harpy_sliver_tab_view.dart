import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// A sliver page view that displays the widget which corresponds to the
/// currently selected [HarpyTab].
class HarpySliverTabView extends StatelessWidget {
  const HarpySliverTabView({
    required this.tabs,
    required this.children,
    this.headerSlivers,
  }) : assert(tabs.length == children.length);

  final List<Widget> tabs;
  final List<Widget> children;
  final List<Widget>? headerSlivers;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: children.length,
      child: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          ...?headerSlivers,
          HarpySliverTapBar(
            tabs: tabs,
          ),
        ],
        body: TabBarView(
          children: children,
        ),
      ),
    );
  }
}
