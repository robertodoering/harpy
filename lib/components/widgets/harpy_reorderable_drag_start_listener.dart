import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Workaround for an issue with the [ReorderableDragStartListener] where a
/// reorder does not occur if the [ReorderableListView] is placed inside another
/// [Scrollable].
class HarpyReorderableDragStartListener extends ReorderableDragStartListener {
  const HarpyReorderableDragStartListener({
    required super.child,
    required super.index,
  });

  @override
  MultiDragGestureRecognizer createRecognizer() {
    return DelayedMultiDragGestureRecognizer(
      debugOwner: this,
      delay: Duration.zero,
    );
  }
}
