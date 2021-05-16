import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Transforms its [child] from a [begin] [Matrix4] transform to an [end]
/// transform.
///
/// [delay] can delay the time it takes for the [child] to start the
/// transformation.
class TransformInAnimation extends StatefulWidget {
  const TransformInAnimation({
    required this.child,
    required this.begin,
    required this.end,
    this.curve = Curves.easeInOut,
    this.duration = kLongAnimationDuration,
    this.delay = Duration.zero,
    this.alignment = Alignment.center,
  });

  /// Scales the [child] from a [beginScale] to an [endScale].
  TransformInAnimation.scale({
    required this.child,
    required double beginScale,
    required double endScale,
    this.curve = Curves.easeInOut,
    this.duration = kLongAnimationDuration,
    this.delay = Duration.zero,
    this.alignment = Alignment.center,
  })  : begin = Matrix4.diagonal3Values(beginScale, beginScale, 1),
        end = Matrix4.diagonal3Values(endScale, endScale, 1);

  final Widget child;
  final Matrix4 begin;
  final Matrix4 end;
  final Curve curve;
  final Duration duration;
  final Duration delay;
  final Alignment alignment;

  @override
  _TransformInAnimationState createState() => _TransformInAnimationState();
}

class _TransformInAnimationState extends State<TransformInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Matrix4> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Matrix4Tween(
      begin: widget.begin,
      end: widget.end,
    ).animate(
      CurveTween(curve: widget.curve).animate(_controller),
    );

    Future<void>.delayed(widget.delay).then((_) {
      if (mounted) {
        _controller.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Transform(
        transform: _animation.value,
        alignment: widget.alignment,
        child: widget.child,
      ),
    );
  }
}
