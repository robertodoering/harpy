import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rby/rby.dart';

/// Listens to the [controller] and calls the [onLoadMore] callback when
/// reaching the end of the scrollable.
///
/// Similar to [LoadMoreListener], except an explicit [controller] is provided
/// which allows us to query the scrollable's extent after loading more to
/// continuesly call [onLoadMore].
class LoadMoreHandler extends StatefulWidget {
  const LoadMoreHandler({
    required this.child,
    required this.controller,
    required this.onLoadMore,
    this.listen = true,
    this.extentTrigger,
  });

  final Widget child;
  final ScrollController controller;
  final AsyncCallback onLoadMore;
  final bool listen;

  /// How little quantity of content conceptually "below" the viewport needs to
  /// be scrollable to trigger the [onLoadMore].
  ///
  /// Defaults to half of the scrollable's viewport size.
  final double? extentTrigger;

  @override
  State<LoadMoreHandler> createState() => _LoadMoreHandlerState();
}

class _LoadMoreHandlerState extends State<LoadMoreHandler> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scrollListener);

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LoadMoreHandler oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When re-enabling the listener, we want to query the current scroll extent
    // to potentially call the callback.
    if (!oldWidget.listen && widget.listen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollListener());
    }
  }

  void _scrollListener() {
    if (_loading || !widget.listen || !mounted) return;
    assert(widget.controller.hasClients);
    if (widget.controller.positions.length != 1) return;

    final position = widget.controller.positions.first;

    if (position.extentAfter <=
        (widget.extentTrigger ?? position.viewportDimension / 2)) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_loading) return;

    if (mounted) setState(() => _loading = true);
    await widget.onLoadMore();
    if (mounted) setState(() => _loading = false);

    // After loading more, re-trigger the listener in case the scroll extent is
    // still below the extent trigger.
    _scrollListener();
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification.metrics.extentAfter <=
        (widget.extentTrigger ?? notification.metrics.viewportDimension / 2)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadMore());
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: widget.listen && !_loading ? _onNotification : null,
      child: widget.child,
    );
  }
}
