import 'package:flutter/widgets.dart';
import 'package:harpy/rby/animations/immediate/immediate_animation.dart';

/// Animates the offset relative to the [child] normal position immediately or
/// after the given [delay].
class ImmediateSlideAnimation extends ImmediateImplicitAnimation<Offset> {
  const ImmediateSlideAnimation({
    required super.child,
    required super.duration,
    super.begin = Offset.zero,
    super.end = Offset.zero,
    super.curve,
    super.delay,
  });

  @override
  ImmediateImplictAnimationState<ImmediateImplicitAnimation<Offset>, Offset>
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
