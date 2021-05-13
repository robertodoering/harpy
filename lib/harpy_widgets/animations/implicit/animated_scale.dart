import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// An implicitly animated widget that will animate a change to [scale].
class AnimatedScale extends ImplicitlyAnimatedWidget {
  const AnimatedScale({
    required this.scale,
    required this.child,
    Curve curve = Curves.easeInOut,
    Duration duration = kShortAnimationDuration,
  }) : super(curve: curve, duration: duration);

  final double scale;
  final Widget child;

  @override
  _AnimatedScaleState createState() => _AnimatedScaleState();
}

class _AnimatedScaleState extends AnimatedWidgetBaseState<AnimatedScale> {
  Tween<double>? _scaleTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _scaleTween = visitor(
      _scaleTween,
      widget.scale,
      (dynamic value) => Tween<double>(begin: value),
    ) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scaleTween?.evaluate(animation) ?? 1,
      child: widget.child,
    );
  }
}
