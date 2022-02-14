import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

// TODO: refactor

class HarpyTabBar extends ConsumerStatefulWidget {
  const HarpyTabBar({
    required this.tabs,
    required this.padding,
    this.endWidgets,
  });

  final List<Widget> tabs;

  /// A list of additional widgets that will be built at the end of the tab bar.
  final List<Widget>? endWidgets;

  /// Padding around the [tabs] inside the scroll view.
  final EdgeInsets padding;

  @override
  _HarpyTapBarState createState() => _HarpyTapBarState();
}

class _HarpyTapBarState extends ConsumerState<HarpyTabBar> {
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

  Widget _buildTab(HarpyTheme harpyTheme, int index) {
    return AutoScrollTag(
      key: ValueKey<int>(index),
      controller: _scrollController!,
      index: index,
      child: InkWell(
        borderRadius: harpyTheme.borderRadius,
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
    final harpyTheme = ref.watch(harpyThemeProvider);

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: widget.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < widget.tabs.length; i++) ...[
            _buildTab(harpyTheme, i),
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

class HarpyTabScope extends InheritedWidget {
  const HarpyTabScope({
    required this.index,
    required this.animationValue,
    required Widget child,
  }) : super(child: child);

  final int index;

  /// A value between 0 and 1 that corresponds to how much the tab content
  /// for [index] is in view.
  final double animationValue;

  static HarpyTabScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HarpyTabScope>();
  }

  @override
  bool updateShouldNotify(HarpyTabScope oldWidget) {
    return oldWidget.index != index ||
        oldWidget.animationValue != animationValue;
  }
}