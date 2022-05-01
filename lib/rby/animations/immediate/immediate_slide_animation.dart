import 'package:flutter/widgets.dart';
import 'package:harpy/rby/animations/immediate/immediate_animation.dart';

/// Animates the offset relative to the [child] normal position immediately or
/// after the given [delay].
class ImmediateSlideAnimation extends ImmediateImplicitAnimation<Offset> {
  const ImmediateSlideAnimation({
    required Widget child,
    required Duration duration,
    Offset begin = Offset.zero,
    Offset end = Offset.zero,
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
  ImmediateImplictAnimationState<ImmediateImplicitAnimation, Offset>
      createState() => _ImmediateSlideAnimationState();
}

class _ImmediateSlideAnimationState
    extends ImmediateImplictAnimationState<ImmediateSlideAnimation, Offset> {
  @override
  ImplicitlyAnimatedWidget buildAnimated(Widget child, Offset value) {
    return AnimatedSlide(
      offset: value,
      duration: widget.duration,
      curve: widget.curve,
      child: widget.child,
    );
  }
}
