import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Specifies what icon of the [AnimatedIconData] to show.
enum AnimatedIconState {
  showFirst,
  showSecond,
}

/// Animates the [icon] whenever the [animatedIconState] changes.
class ImplicitlyAnimatedIcon extends StatefulWidget {
  const ImplicitlyAnimatedIcon({
    required this.icon,
    required this.animatedIconState,
    this.color,
    this.size,
    this.curve = Curves.easeInOut,
    this.duration = kShortAnimationDuration,
  });

  /// The animated icon data that is used in an [AnimatedIcon] widget.
  final AnimatedIconData icon;

  /// Determines if the first or second icon of the [AnimatedIconData] should
  /// be shown.
  final AnimatedIconState animatedIconState;

  /// The color of the [icon].
  final Color? color;

  /// The size of the [icon].
  final double? size;

  final Curve curve;
  final Duration duration;

  @override
  _ImplicitlyAnimatedIconState createState() => _ImplicitlyAnimatedIconState();
}

class _ImplicitlyAnimatedIconState extends State<ImplicitlyAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool get _showFirst =>
      widget.animatedIconState == AnimatedIconState.showFirst;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      value: _showFirst ? 0 : 1,
      duration: widget.duration,
    );
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
      color: widget.color,
      progress: _controller,
      size: widget.size,
    );
  }
}
