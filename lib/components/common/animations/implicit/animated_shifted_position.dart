import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/misc/shifted_position.dart';

/// Implicitly animates the position of the [child] relative to the size of the
/// [child].
class AnimatedShiftedPosition extends ImplicitlyAnimatedWidget {
  const AnimatedShiftedPosition({
    @required this.child,
    @required this.shift,
    this.hideOnCompletion = false,
    Curve curve = Curves.easeInOut,
    Duration duration = kShortAnimationDuration,
  }) : super(curve: curve, duration: duration);

  final Widget child;
  final Offset shift;

  /// Whether an empty child should be built when the animation completes.
  final bool hideOnCompletion;

  @override
  _AnimatedRelativePositionState createState() =>
      _AnimatedRelativePositionState();
}

class _AnimatedRelativePositionState
    extends AnimatedWidgetBaseState<AnimatedShiftedPosition> {
  Tween<Offset> _offsetTween;

  @override
  void forEachTween(dynamic visitor) {
    _offsetTween = visitor(
      _offsetTween,
      widget.shift,
      (dynamic value) => Tween<Offset>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Offset offset = _offsetTween.evaluate(animation);

    if (widget.hideOnCompletion && animation.isCompleted) {
      return const SizedBox();
    } else {
      return ShiftedPosition(
        shift: offset,
        child: widget.child,
      );
    }
  }
}
