import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Listens to scroll notifications that bubble up the tree to call the
/// [onLoadMore] callback when reaching the end of the list.
class LoadMoreListener extends StatefulWidget {
  const LoadMoreListener({
    required this.child,
    this.listen = true,
    this.onLoadMore,
  });

  final Widget child;
  final bool listen;
  final AsyncCallback? onLoadMore;

  @override
  _LoadMoreListenerState createState() => _LoadMoreListenerState();
}

class _LoadMoreListenerState extends State<LoadMoreListener> {
  bool _loading = false;

  Future<void> _loadMore() async {
    if (_loading) {
      return;
    }

    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    await widget.onLoadMore!();

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification.metrics.extentAfter <= 600) {
      _loadMore();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: !widget.listen || _loading ? null : _onNotification,
      child: widget.child,
    );
  }
}
