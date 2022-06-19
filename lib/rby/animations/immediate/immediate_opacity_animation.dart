import 'package:flutter/widgets.dart';
import 'package:harpy/rby/rby.dart';

/// Animates the opacity for the [child] immediately or after the given [delay].
class ImmediateOpacityAnimation extends ImmediateImplicitAnimation<double> {
  const ImmediateOpacityAnimation({
    required super.child,
    required super.duration,
    super.begin = 0,
    super.end = 1,
    super.curve,
    super.delay,
    super.key,
  });

  @override
  ImmediateImplictAnimationState<ImmediateOpacityAnimation, double>
      createState() => _ImmediateOpacityAnimationState();
}

class _ImmediateOpacityAnimationState
    extends ImmediateImplictAnimationState<ImmediateOpacityAnimation, double> {
  @override
  ImplicitlyAnimatedWidget buildAnimated(Widget child, double value) {
    return AnimatedOpacity(
      opacity: value,
      duration: widget.duration,
      curve: widget.curve,
      child: widget.child,
    );
  }
}
