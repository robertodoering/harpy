import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Used by [HarpySliverTabView] to build the [HarpyTab]s.
class HarpySliverTapBar extends StatelessWidget {
  const HarpySliverTapBar({
    required this.tabs,
  });

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return SliverToBoxAdapter(
      child: Padding(
        padding: config.edgeInsetsOnly(top: true),
        child: Center(
          child: HarpyTabBar(
            tabs: tabs,
          ),
        ),
      ),
    );
  }
}
