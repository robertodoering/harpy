import 'package:flutter/material.dart';

/// An asynchronous callback that is used to load more data.
typedef OnLoadMore = Future<void> Function();

/// A builder for the widget that is built at the bottom of the list while
/// loading more data.
typedef LoadingBuilder = Widget Function();

/// Wraps a list and listens to its [ScrollNotification] to call the
/// [onLoadMore] callback when the end of the list has been reached.
///
/// While the [onLoadMore] callback is not completed, a loading widget is
/// built at the end of the list.
/// The [loadingBuilder] is used to build that widget. Alternatively a
/// default loading widget is used with the [loadingText].
///
/// Only works when using a [ListView] with a [SliverChildBuilderDelegate]
/// like [ListView.builder].
class LoadMoreList extends StatefulWidget {
  LoadMoreList({
    @required this.child,
    this.onLoadMore,
    this.enable = true,
    this.disabledWidget,
    this.loadingBuilder,
    this.loadingText = 'Loading...',
    this.triggerExtend = 200,
  })  : assert(loadingBuilder != null || loadingText != null),
        assert(child.childrenDelegate is SliverChildBuilderDelegate);

  /// The [ListView] that should call the [onLoadMore] callback when reaching
  /// the end of the list.
  final ListView child;

  /// Used to build the widget at the bottom of the list while loading more.
  ///
  /// Defaults to the default loading builder if `null`.
  final LoadingBuilder loadingBuilder;

  /// Used by the default loading builder.
  final String loadingText;

  /// The callback when reaching the end of the list to load more.
  ///
  /// Error handling should be done in the [onLoadMore] callback.
  final OnLoadMore onLoadMore;

  /// Whether the [onLoadMore] callback should be called when reaching the end
  /// of the list.
  ///
  /// This should be set to `false` when no more data can be loaded.
  /// For example when reaching the last page of a paginated response.
  final bool enable;

  /// A widget that is built at the end of the list when [enabled] is `true`.
  final Widget disabledWidget;

  /// The distance in pixels that the scroll position needs to be away from
  /// the bottom of the [child] for the [onLoadMore] to trigger.
  final double triggerExtend;

  @override
  State<StatefulWidget> createState() => _LoadMoreListState();
}

class _LoadMoreListState extends State<LoadMoreList> {
  bool _loading = false;

  /// `true` if the [widget.onLoadMore] callback should get evoked.
  bool get listen => widget.enable && !_loading && widget.onLoadMore != null;

  Future<void> _loadMore() async {
    if (_loading) {
      return;
    }

    setState(() => _loading = true);
    await widget.onLoadMore();
    setState(() => _loading = false);
  }

  bool _onScrollNotification(ScrollNotification notification) {
    final double scrollPosition = notification.metrics.pixels;
    final double maxScrollExtend = notification.metrics.maxScrollExtent;

    if (notification is ScrollUpdateNotification) {
      if (maxScrollExtend - scrollPosition <= widget.triggerExtend) {
        _loadMore();
      }
    }

    return false;
  }

  /// Builds the default loading widget.
  ///
  /// The [widget.loadingBuilder] is used to build the loading widget instead,
  /// if it is not `null`.
  Widget _buildDefaultLoadingWidget() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.loadingText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  /// Returns the widget intended to be built at the end of the list.
  ///
  /// Either a loading widget or the [widget.disabledWidget].
  ///
  /// Returns `null` if no widget is to be appended at the end of the list.
  Widget _buildFooter() {
    if (_loading) {
      return widget.loadingBuilder?.call() ?? _buildDefaultLoadingWidget();
    } else if (!widget.enable) {
      return widget.disabledWidget;
    } else {
      return null;
    }
  }

  /// Builds the [widget.child] with a widget at the end of the list that is
  /// returned by [_buildFooter].
  Widget _buildListView() {
    final ListView listView = widget.child;
    final SliverChildDelegate delegate = listView.childrenDelegate;

    if (delegate is SliverChildBuilderDelegate) {
      final Widget footer = _buildFooter();

      final int itemCount = footer != null
          ? delegate.estimatedChildCount + 1
          : delegate.estimatedChildCount;

      // the item builder when the loading footer is showing
      Widget itemBuilder(BuildContext context, int index) {
        if (footer != null && index == itemCount - 1) {
          return footer;
        }
        return delegate.builder(context, index);
      }

      return ListView.builder(
        key: listView.key,
        itemBuilder: itemBuilder,
        addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
        addRepaintBoundaries: delegate.addRepaintBoundaries,
        addSemanticIndexes: delegate.addSemanticIndexes,
        dragStartBehavior: listView.dragStartBehavior,
        semanticChildCount: listView.semanticChildCount,
        itemCount: itemCount,
        cacheExtent: listView.cacheExtent,
        controller: listView.controller,
        itemExtent: listView.itemExtent,
        padding: listView.padding,
        physics: listView.physics,
        primary: listView.primary,
        reverse: listView.reverse,
        scrollDirection: listView.scrollDirection,
        shrinkWrap: listView.shrinkWrap,
      );
    }

    return listView;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: listen ? _onScrollNotification : null,
      child: _buildListView(),
    );
  }
}
