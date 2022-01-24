import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class HarpyTabBar extends StatefulWidget {
  const HarpyTabBar({
    required this.tabs,
    this.endWidgets,
    this.padding,
  });

  final List<Widget> tabs;

  /// A list of additional widgets that will be built at the end of the tab bar.
  final List<Widget>? endWidgets;

  /// Padding around the [tabs] inside the scroll view.
  ///
  /// Defaults to horizontal default edge insets.
  final EdgeInsets? padding;

  @override
  _HarpyTapBarState createState() => _HarpyTapBarState();
}

class _HarpyTapBarState extends State<HarpyTabBar> {
  late AutoScrollController? _scrollController;
  late TabController? _tabController;

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
    _tabController?.animation?.addListener(_tabControllerListener);
  }

  @override
  void dispose() {
    super.dispose();

    _tabController?.animation?.removeListener(_tabControllerListener);
    _scrollController?.dispose();
  }

  void _tabControllerListener() {
    if (mounted) {
      // rebuild tabs with new animation value
      setState(() {});

      final newIndex = _tabController?.animation?.value.round() ?? 0;

      if (_currentIndex != newIndex) {
        // content changed, scroll tab bar to show active tab

        // we delay until we scroll in case the index changed in quick
        // succession (e.g. when switching from index 0 to 3, the index changes
        // from 0 to 1 to 2 and finally to 3)
        Future<void>.delayed(const Duration(milliseconds: 100)).then((_) {
          if (_currentIndex == newIndex) {
            _scrollToIndex(newIndex);
          }
        });
      }

      _currentIndex = newIndex;
    }
  }

  void _scrollToIndex(int index) {
    _scrollController?.scrollToIndex(
      index,
      duration: kLongAnimationDuration,
      preferPosition: AutoScrollPosition.middle,
    );
  }

  double _animationValue(int index) =>
      (_tabController!.animation!.value - index).clamp(-1, 1).abs().toDouble();

  Widget _buildTab(int index) {
    return AutoScrollTag(
      key: ValueKey<int>(index),
      controller: _scrollController!,
      index: index,
      child: InkWell(
        borderRadius: kBorderRadius,
        onTap: () => _tabController!.animateTo(index),
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
    final config = context.watch<ConfigCubit>().state;

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: widget.padding ?? config.edgeInsetsSymmetric(horizontal: true),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < widget.tabs.length; i++) ...[
            _buildTab(i),
            if (i != widget.tabs.length - 1) smallHorizontalSpacer,
          ],
          if (widget.endWidgets != null) ...[
            for (Widget widget in widget.endWidgets!) ...[
              smallHorizontalSpacer,
              widget,
            ],
          ],
        ],
      ),
    );
  }
}
