import 'package:flutter/widgets.dart';
import 'package:harpy/rby/rby.dart';

/// Animates the scale for the [child] immediately or after the given [delay].
class ImmediateScaleAnimation extends ImmediateImplicitAnimation<double> {
  const ImmediateScaleAnimation({
    required Widget child,
    required Duration duration,
    double begin = 1,
    double end = 1,
    Curve curve = Curves.easeInOut,
    Duration delay = Duration.zero,
  }) : super(
          child: child,
          duration: duration,
          begin: begin,
          end: end,
          curve: curve,
          delay: delay,
        );

  @override
  ImmediateImplictAnimationState<ImmediateImplicitAnimation, double>
      createState() => _ImmediateScaleAnimationState();
}

class _ImmediateScaleAnimationState
    extends ImmediateImplictAnimationState<ImmediateScaleAnimation, double> {
  @override
  ImplicitlyAnimatedWidget buildAnimated(Widget child, double value) {
    return AnimatedScale(
      scale: value,
      duration: widget.duration,
      curve: widget.curve,
      child: widget.child,
    );
  }
}
