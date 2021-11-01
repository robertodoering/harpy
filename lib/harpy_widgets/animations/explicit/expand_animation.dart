import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Used by [ExpandAnimation] to determine whether to expand in or expand out
/// its child.
enum ExpandType {
  expandIn,
  expandOut,
}

/// Expands its [child] either in or out upon creation.
///
/// [delay] can delay the time it takes for the [child] to start the
/// change in opacity.
class ExpandAnimation extends StatefulWidget {
  const ExpandAnimation({
    required this.child,
    this.expandType = ExpandType.expandIn,
    this.curve = Curves.fastOutSlowIn,
    this.duration = kShortAnimationDuration,
    this.delay = Duration.zero,
    this.onAnimated,
  });

  final Widget child;
  final ExpandType expandType;
  final Curve curve;
  final Duration duration;
  final Duration delay;
  final VoidCallback? onAnimated;

  @override
  _ExpandAnimationState createState() => _ExpandAnimationState();
}

class _ExpandAnimationState extends State<ExpandAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener(_animationListener);

    final tween = widget.expandType == ExpandType.expandIn
        ? Tween<double>(begin: 0, end: 1)
        : Tween<double>(begin: 1, end: 0);

    _animation = tween.animate(
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

  void _animationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onAnimated?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      child: widget.child,
    );
  }
}
