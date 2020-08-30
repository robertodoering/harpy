import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

/// Wraps the [ReorderableList] to allow the [children] to reorder.
///
/// The [children] must build their own [ReorderableListener] that will start a
/// reorder on drag.
class CustomReorderableList extends StatefulWidget {
  const CustomReorderableList({
    @required this.children,
    @required this.onReorder,
    this.physics,
    this.padding = EdgeInsets.zero,
    this.shrinkWrap = false,
    this.reorderOpacity = .8,
    this.separatorBuilder,
  });

  /// The children for the [ReorderableList].
  final List<Widget> children;

  /// The physics for the [ListView].
  final ScrollPhysics physics;

  /// The padding for the [children].
  final EdgeInsets padding;

  /// The shrink wrap for the [ListView].
  final bool shrinkWrap;

  /// Called whenever the [children] have been reordered.
  final ReorderCallback onReorder;

  /// The opacity of the child when it is being reordered.
  final double reorderOpacity;

  /// An optional separator builder that builds between each item.
  final IndexedWidgetBuilder separatorBuilder;

  @override
  State<CustomReorderableList> createState() => _CustomReorderableListState();
}

class _CustomReorderableListState extends State<CustomReorderableList> {
  int _newIndex;
  List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = List<Widget>.from(widget.children);
  }

  @override
  void didUpdateWidget(CustomReorderableList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _children = List<Widget>.from(widget.children);
  }

  int _oldIndexOfKey(Key key) {
    return widget.children.indexWhere(
      (Widget widget) => ValueKey<int>(widget.hashCode) == key,
    );
  }

  int _indexOfKey(Key key) {
    return _children.indexWhere(
      (Widget widget) => ValueKey<int>(widget.hashCode) == key,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return _CustomReorderableItem(
      key: ValueKey<int>(_children[index].hashCode),
      reorderOpacity: widget.reorderOpacity,
      child: _children[index],
    );
  }

  Widget _buildListView() {
    if (widget.separatorBuilder != null) {
      return ListView.separated(
        physics: widget.physics,
        padding: widget.padding,
        shrinkWrap: widget.shrinkWrap,
        itemCount: _children.length,
        itemBuilder: _itemBuilder,
        separatorBuilder: widget.separatorBuilder,
      );
    } else {
      return ListView.builder(
        physics: widget.physics,
        padding: widget.padding,
        shrinkWrap: widget.shrinkWrap,
        itemCount: _children.length,
        itemBuilder: _itemBuilder,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableList(
      decoratePlaceholder: (Widget widget, double decorationOpacity) =>
          DecoratedPlaceholder(offset: 0, widget: widget),
      onReorder: (Key draggedItem, Key newPosition) {
        final int draggingIndex = _indexOfKey(draggedItem);
        final int newPositionIndex = _indexOfKey(newPosition);

        final Widget item = _children[draggingIndex];

        setState(() {
          _newIndex = newPositionIndex;

          _children
            ..removeAt(draggingIndex)
            ..insert(newPositionIndex, item);
        });

        return true;
      },
      onReorderDone: (Key draggedItem) {
        final int oldIndex = _oldIndexOfKey(draggedItem);
        if (_newIndex != null) {
          widget.onReorder(oldIndex, _newIndex);
        }
        _newIndex = null;
      },
      child: _buildListView(),
    );
  }
}

/// Builds the [ReorderableItem] for a [CustomReorderableList].
class _CustomReorderableItem extends StatelessWidget {
  const _CustomReorderableItem({
    @required Key key,
    @required this.child,
    @required this.reorderOpacity,
  }) : super(key: key);

  final Widget child;

  final double reorderOpacity;

  double _opacity(ReorderableItemState state) {
    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      return reorderOpacity;
    } else if (state == ReorderableItemState.placeholder) {
      return 0;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key: key,
      childBuilder: (BuildContext context, ReorderableItemState state) {
        return Opacity(
          opacity: _opacity(state),
          child: child,
        );
      },
    );
  }
}
