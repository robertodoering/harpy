import 'package:flutter/material.dart';

/// Specifies what icon of the [AnimatedIconData] to show.
enum AnimatedIconState {
  showFirst,
  showSecond,
}

/// Animates the [icon] whenever the [animatedIconState] changes.
class ImplicitlyAnimatedIcon extends StatefulWidget {
  const ImplicitlyAnimatedIcon({
    @required this.icon,
    @required this.animatedIconState,
    this.curve = Curves.easeInOut,
    this.duration = const Duration(milliseconds: 300),
  });

  /// The animated icon data that is used in an [AnimatedIcon] widget.
  final AnimatedIconData icon;

  /// Determines if the first or second icon of the [AnimatedIconData] should
  /// be shown.
  final AnimatedIconState animatedIconState;

  final Curve curve;
  final Duration duration;

  @override
  _ImplicitlyAnimatedIconState createState() => _ImplicitlyAnimatedIconState();
}

class _ImplicitlyAnimatedIconState extends State<ImplicitlyAnimatedIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  bool get _showFirst =>
      widget.animatedIconState == AnimatedIconState.showFirst;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      value: _showFirst ? 0 : 1,
      duration: widget.duration,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(ImplicitlyAnimatedIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animatedIconState != widget.animatedIconState) {
      if (_showFirst) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedIcon(
      icon: widget.icon,
      progress: _controller,
    );
  }
}

/// An implicitly animated widget that will animate a change to [scale].
class AnimatedScale extends ImplicitlyAnimatedWidget {
  const AnimatedScale({
    @required this.scale,
    @required this.child,
    Curve curve = Curves.easeInCubic,
    Duration duration = const Duration(milliseconds: 100),
  }) : super(curve: curve, duration: duration);

  final double scale;
  final Widget child;

  @override
  _AnimatedScaleState createState() => _AnimatedScaleState();
}

class _AnimatedScaleState extends AnimatedWidgetBaseState<AnimatedScale> {
  Tween<double> _scaleTween;

  @override
  void forEachTween(visitor) {
    _scaleTween = visitor(
      _scaleTween,
      widget.scale,
      (value) => Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scaleTween.evaluate(animation),
      child: widget.child,
    );
  }
}
