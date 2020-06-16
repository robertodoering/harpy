import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';

/// Fades out its [child] upon creation.
class FadeOutWidget extends StatefulWidget {
  const FadeOutWidget({
    @required this.child,
    this.duration = kLongAnimationDuration,
  });

  final Widget child;
  final Duration duration;

  @override
  _FadeOutWidgetState createState() => _FadeOutWidgetState();
}

class _FadeOutWidgetState extends State<FadeOutWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();

    super.initState();
  }

  @override
  void didUpdateWidget(FadeOutWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _controller.forward(from: 0);
    }
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
      builder: (BuildContext context, Widget child) => Opacity(
        opacity: 1 - _controller.value,
        child: child,
      ),
      child: widget.child,
    );
  }
}
