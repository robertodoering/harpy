import 'package:flutter/material.dart';

/// The default duration for a long animation.
const Duration kLongAnimationDuration = Duration(milliseconds: 600);

/// Slides its [child] to the [endPosition] after calling
/// [SlideAnimationState.forward()].
///
/// Can be used in combination with a [GlobalKey] to access its state for
/// triggering the animation.
class SlideAnimation extends StatefulWidget {
  const SlideAnimation({
    @required this.child,
    @required this.endPosition,
    Key key,
    this.duration = kLongAnimationDuration,
  }) : super(key: key);

  final Widget child;
  final Offset endPosition;
  final Duration duration;

  @override
  SlideAnimationState createState() => SlideAnimationState();
}

class SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.endPosition,
    ).animate(CurveTween(curve: Curves.easeInCubic).animate(_controller));

    super.initState();
  }

  /// Starts the animation.
  Future<void> forward() {
    return _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _animation.value,
      child: widget.child,
    );
  }
}
