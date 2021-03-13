import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/sliver_tab_view/harpy_tab.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/theme/harpy_theme.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

/// Used by [HarpySliverTabView] to build the [HarpyTab]s.
class HarpySliverTapBar extends StatefulWidget {
  const HarpySliverTapBar({
    @required this.tabs,
  });

  final List<Widget> tabs;

  @override
  _HarpySliverTapBarState createState() => _HarpySliverTapBarState();
}

class _HarpySliverTapBarState extends State<HarpySliverTapBar> {
  TabController _tabController;
  AutoScrollController _scrollController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = AutoScrollController(axis: Axis.horizontal);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _tabController = DefaultTabController.of(context);
    _tabController.animation.addListener(_tabControllerListener);
  }

  @override
  void dispose() {
    super.dispose();

    _tabController.animation.removeListener(_tabControllerListener);
    _scrollController.dispose();
  }

  void _tabControllerListener() {
    if (mounted) {
      // rebuild tabs with new animation value
      setState(() {});

      final int newIndex = _tabController.animation.value.round();

      if (_currentIndex != newIndex) {
        // content changed, scroll tab bar to show active tab
        _scrollToIndex(newIndex);
      }

      _currentIndex = newIndex;
    }
  }

  void _scrollToIndex(int index) {
    _scrollController.scrollToIndex(
      index,
      duration: kLongAnimationDuration,
      preferPosition: AutoScrollPosition.middle,
    );
  }

  double _animationValue(int index) =>
      (_tabController.animation.value - index).clamp(-1, 1).abs().toDouble();

  Widget _buildTab(int index) {
    return AutoScrollTag(
      key: ValueKey<int>(index),
      controller: _scrollController,
      index: index,
      child: InkWell(
        borderRadius: kDefaultBorderRadius,
        onTap: () => _tabController.animateTo(index),
        child: HarpyTabScope(
          index: index,
          animationValue: _animationValue(index),
          child: widget.tabs[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: DefaultEdgeInsets.only(top: true),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: DefaultEdgeInsets.symmetric(horizontal: true),
            child: Row(
              children: <Widget>[
                for (int i = 0; i < widget.tabs.length; i++) ...<Widget>[
                  _buildTab(i),
                  if (i != widget.tabs.length - 1) defaultSmallHorizontalSpacer,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
