import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Slides its [child] to the [endPosition] after calling
/// [SlideAnimationState.forward()].
///
/// Can be used in combination with a [GlobalKey] to access its state for
/// triggering the animation.
class SlideAnimation extends StatefulWidget {
  const SlideAnimation({
    required this.child,
    required this.endPosition,
    Key? key,
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
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);

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
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) => Transform.translate(
        offset: _animation.value,
        child: child,
      ),
      child: widget.child,
    );
  }
}
