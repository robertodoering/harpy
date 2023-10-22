import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rby/rby.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

// FIXME: refactor

class HarpyTabBar extends ConsumerStatefulWidget {
  const HarpyTabBar({
    required this.tabs,
    required this.padding,
    this.endWidgets,
    this.controller,
    this.enabled = true,
  });

  final List<Widget> tabs;

  /// A list of additional widgets that will be built at the end of the tab bar.
  final List<Widget>? endWidgets;

  /// Padding around the [tabs] inside the scroll view.
  final EdgeInsetsGeometry padding;

  final TabController? controller;
  final bool enabled;

  @override
  ConsumerState<HarpyTabBar> createState() => _HarpyTapBarState();
}

class _HarpyTapBarState extends ConsumerState<HarpyTabBar> {
  final _scrollController = AutoScrollController(axis: Axis.horizontal);

  TabController? _tabController;
  double _animationValue = 0;

  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_tabController == null) {
      _tabController = widget.controller ?? DefaultTabController.of(context);
      _tabController?.animation?.addListener(_tabControllerListener);
      _animationValue = _tabController?.animation?.value ?? 0;
      assert(_tabController != null);
    }
  }

  @override
  void didUpdateWidget(covariant HarpyTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != null &&
        oldWidget.controller != widget.controller) {
      _tabController = widget.controller!
        ..animation?.addListener(_tabControllerListener);
      // we set the animation value to the last entry to prevent the animation
      // to flicker when updating the controller (which only happens when we are
      // on the last tab)
      _animationValue = widget.controller!.length - 1;
    }
  }

  @override
  void dispose() {
    super.dispose();

    _tabController?.animation?.removeListener(_tabControllerListener);
    _scrollController.dispose();
  }

  void _tabControllerListener() {
    if (mounted) {
      // rebuild tabs with new animation value
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => setState(
          () => _animationValue = _tabController?.animation?.value ?? 0,
        ),
      );

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
    final theme = Theme.of(context);

    _scrollController.scrollToIndex(
      index,
      duration: theme.animation.long,
      preferPosition: AutoScrollPosition.middle,
    );
  }

  double _tabAnimationValue(int index) =>
      (_animationValue - index).clamp(-1, 1).abs().toDouble();

  Widget _buildTab(ThemeData theme, int index) {
    return AutoScrollTag(
      key: ValueKey<int>(index),
      controller: _scrollController,
      index: index,
      child: InkWell(
        borderRadius: theme.shape.borderRadius,
        onTap: widget.enabled ? () => _tabController!.animateTo(index) : null,
        child: HarpyTabScope(
          index: index,
          animationValue: _tabAnimationValue(index),
          child: widget.tabs[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScrollConfiguration(
      behavior: const BasicScrollBehavior(),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: widget.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < widget.tabs.length; i++) ...[
              _buildTab(theme, i),
              if (i != widget.tabs.length - 1) HorizontalSpacer.small,
            ],
            if (widget.endWidgets != null) ...[
              for (final Widget widget in widget.endWidgets!) ...[
                HorizontalSpacer.small,
                widget,
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class HarpyTabScope extends InheritedWidget {
  const HarpyTabScope({
    required this.index,
    required this.animationValue,
    required super.child,
  });

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
