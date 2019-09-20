import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Positions the [child] in the [shift] position relative to the size of the
/// [child].
///
/// It's basically a [Transform.translate] where the [Offset.dx] is
/// multiplied by the [child]s width and the [Offset.dy] is multiplied by the
/// [child]s height.
class ShiftedPosition extends SingleChildRenderObjectWidget {
  const ShiftedPosition({
    Widget child,
    this.shift = Offset.zero,
  }) : super(child: child);

  final Offset shift;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderShiftedPositioned(
      shift: shift,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderShiftedPositioned renderObject,
  ) {
    renderObject..shift = shift;
  }
}

class _RenderShiftedPositioned extends RenderShiftedBox {
  _RenderShiftedPositioned({
    RenderBox child,
    Offset shift = Offset.zero,
  })  : _shift = shift,
        super(child);

  set shift(Offset shift) {
    if (shift != _shift) {
      _shift = shift;
      markNeedsLayout();
    }
  }

  Offset _shift;

  @override
  void performLayout() {
    if (child != null) {
      child.layout(constraints..tighten(), parentUsesSize: true);
      size = child.size;
    } else {
      size = Size.zero;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final BoxParentData childParentData = child.parentData;

      // the shift multiplied by the child's size
      final shiftOffset = Offset(
        _shift.dx * child.size.width,
        _shift.dy * child.size.height,
      );

      context.paintChild(
        child,
        childParentData.offset + offset + shiftOffset,
      );
    }
  }
}
