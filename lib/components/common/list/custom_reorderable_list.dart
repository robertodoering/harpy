import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:harpy/components/common/animations/explicit/expand_animation.dart';

/// Wraps the [ReorderableList] to allow the [children] to reorder.
///
/// The [ReorderableList] is an implementation of a reorderable list from the
/// [flutter_reorderable_list](https://pub.dev/packages/flutter_reorderable_list)
/// package.
/// This implementation looks and feels a lot better than the default flutter
/// [ReorderableListView].
///
/// The [children] must build their own [ReorderableListener] that will start a
/// reorder on drag.
class CustomReorderableList extends StatefulWidget {
  CustomReorderableList({
    @required this.children,
    @required this.onReorder,
    this.physics,
    this.padding = EdgeInsets.zero,
    this.shrinkWrap = false,
    this.reorderOpacity = .8,
    this.separatorBuilder,
  }) : assert(
          children.every((Widget w) => w.key != null),
          'All children of this widget must have a key.',
        );

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
    final List<Widget> oldChildren = List<Widget>.from(oldWidget.children);

    if (oldChildren.length != _children.length) {
      _animateUpdateDifference(oldChildren);
    }
  }

  /// Wraps the updated child in an [ExpandedAnimation] to implicitly animate an
  /// update in the [widget.children].
  void _animateUpdateDifference(List<Widget> oldChildren) {
    final int index = _findListDifference(oldChildren, _children);

    if (oldChildren.length < widget.children.length) {
      // added widget
      final Widget newChild = _children[index];

      _children[index] = ExpandAnimation(
        key: newChild.key,
        onAnimated: () {
          if (mounted) {
            try {
              _children[index] = newChild;
            } catch (e) {
              // children state might have updated during animation, ignore
            }
          }
        },
        child: _children.last,
      );
    } else {
      // removed widget
      final Widget removedChild = oldChildren[index];

      _children.insert(
        index,
        ExpandAnimation(
          // key: removedChild.key,
          expandType: ExpandType.expandOut,
          onAnimated: () {
            if (mounted) {
              setState(() {
                try {
                  _children.removeAt(index);
                } catch (e) {
                  // children state might have updated during animation,
                  // ignore
                }
              });
            }
          },
          child: removedChild,
        ),
      );
    }
  }

  /// Finds the index where key of the [oldChildren] and [newChildren] entry
  /// differs.
  ///
  /// Returns `-1` when the lists are identical.
  int _findListDifference(List<Widget> oldChildren, List<Widget> newChildren) {
    for (int i = 0; i < max(oldChildren.length, newChildren.length); i++) {
      if (oldChildren.length - 1 < i || newChildren.length - 1 < i) {
        return i;
      }

      if (oldChildren[i].key != newChildren[i].key) {
        return i;
      }
    }

    return -1;
  }

  int _oldIndexOfKey(Key key) {
    return widget.children.indexWhere((Widget widget) => widget.key == key);
  }

  int _indexOfKey(Key key) {
    return _children.indexWhere((Widget widget) => widget.key == key);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return _CustomReorderableItem(
      key: _children[index].key,
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
