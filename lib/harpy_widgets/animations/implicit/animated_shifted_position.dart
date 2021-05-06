import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Implicitly animates the position of the [child] relative to the size of the
/// [child].
class AnimatedShiftedPosition extends ImplicitlyAnimatedWidget {
  const AnimatedShiftedPosition({
    required this.child,
    required this.shift,
    Curve curve = Curves.easeInOut,
    Duration duration = kShortAnimationDuration,
  }) : super(curve: curve, duration: duration);

  final Widget child;
  final Offset shift;

  @override
  _AnimatedRelativePositionState createState() =>
      _AnimatedRelativePositionState();
}

class _AnimatedRelativePositionState
    extends AnimatedWidgetBaseState<AnimatedShiftedPosition> {
  Tween<Offset>? _offsetTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    final newTween = visitor(
      _offsetTween,
      widget.shift,
      (dynamic value) => Tween<Offset>(begin: value),
    );

    if (newTween is Tween<Offset>) {
      _offsetTween = newTween;
    }
  }

  @override
  Widget build(BuildContext context) {
    final offset = _offsetTween!.evaluate(animation);

    return ShiftedPosition(
      shift: offset,
      child: widget.child,
    );
  }
}
