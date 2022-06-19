import 'package:flutter/material.dart';

/// Similar to [DefaultTabController] but has customized behavior when we update
/// the length of the controller.
class HomeTabController extends StatefulWidget {
  const HomeTabController({
    required this.length,
    required this.child,
    this.initialIndex = 0,
    this.animationDuration,
  })  : assert(length >= 0),
        assert(length == 0 || (initialIndex >= 0 && initialIndex < length));

  final int length;
  final int initialIndex;
  final Duration? animationDuration;
  final Widget child;

  static TabController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_TabControllerScope>()
        ?.controller;
  }

  @override
  State<HomeTabController> createState() => _HomeTabControllerState();
}

class _HomeTabControllerState extends State<HomeTabController>
    with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TabController(
      vsync: this,
      length: widget.length,
      initialIndex: widget.initialIndex,
      animationDuration: widget.animationDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _TabControllerScope(
      controller: _controller,
      enabled: TickerMode.of(context),
      child: widget.child,
    );
  }

  @override
  void didUpdateWidget(HomeTabController oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.length != widget.length) {
      _controller.dispose();
      _controller = TabController(
        vsync: this,
        length: widget.length,
        // always stay on the last index when the length changes
        initialIndex: widget.length - 1,
        animationDuration: widget.animationDuration,
      );
    }
  }
}

class _TabControllerScope extends InheritedWidget {
  const _TabControllerScope({
    required this.controller,
    required this.enabled,
    required super.child,
  });

  final TabController controller;
  final bool enabled;

  @override
  bool updateShouldNotify(_TabControllerScope old) {
    return enabled != old.enabled || controller != old.controller;
  }
}
