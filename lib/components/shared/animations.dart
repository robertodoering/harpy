import 'package:flutter/material.dart';

/// Slides and fades its child into position upon creation.
class SlideFadeInAnimation extends StatefulWidget {
  /// The duration of the animation.
  final Duration duration;

  /// The delay until the animation starts.
  final Duration delay;

  /// The offset that the child will have before it slides into position.
  final Offset offset;

  /// Skips the intro animation if set to `true`.
  final bool skipIntroAnimation;

  /// An optional callback when the animation has completed.
  final VoidCallback finishCallback;

  /// The child to animate.
  final Widget child;

  SlideFadeInAnimation({
    this.duration = const Duration(seconds: 1),
    this.delay = Duration.zero,
    this.offset = Offset.zero,
    this.skipIntroAnimation = false,
    this.finishCallback = null,
    @required this.child,
  });

  @override
  _SlideFadeInAnimationState createState() => _SlideFadeInAnimationState();
}

class _SlideFadeInAnimationState extends State<SlideFadeInAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.skipIntroAnimation) {
      _controller.value = 1.0;
    }

    // callback when animation has completed
    if (widget.finishCallback != null) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.finishCallback();
        }
      });
    }

    _animation = CurveTween(curve: Curves.fastOutSlowIn).animate(_controller)
      ..addListener(() => setState(() {}));

    Future.delayed(widget.delay).then((_) => _controller.forward());

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _animation.value,
      child: Transform.translate(
        offset: Offset(
          (1 - _animation.value) * widget.offset.dx,
          (1 - _animation.value) * widget.offset.dy,
        ),
        child: widget.child,
      ),
    );
  }
}
