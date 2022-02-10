import 'package:flutter/widgets.dart';
import 'package:harpy/rby/rby.dart';

/// Animates the opacity for the [child] immediately or after the given [delay].
class ImmediateOpacityAnimation extends ImmediateImplicitAnimation<double> {
  const ImmediateOpacityAnimation({
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
