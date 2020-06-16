import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';

/// Builds its [child] translated by [offset] and slides it into position upon
/// creation.
///
/// [delay] can delay the time it takes for the [child] to start the
/// translation.
class SlideInAnimation extends StatefulWidget {
  const SlideInAnimation({
    @required this.child,
    @required this.offset,
    this.duration = kLongAnimationDuration,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Offset offset;
  final Duration duration;
  final Duration delay;

  @override
  _SlideInAnimationState createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  bool _hidden = true;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = CurveTween(curve: Curves.fastOutSlowIn).animate(_controller);

    Future<void>.delayed(widget.delay).then((_) {
      if (mounted) {
        _controller.forward();
        _hidden = false;
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
    if (_hidden) {
      return Container();
    } else {
      return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) => Transform.translate(
          offset: Offset(
            (1 - _animation.value) * widget.offset.dx,
            (1 - _animation.value) * widget.offset.dy,
          ),
          child: widget.child,
        ),
        child: widget.child,
      );
    }
  }
}
