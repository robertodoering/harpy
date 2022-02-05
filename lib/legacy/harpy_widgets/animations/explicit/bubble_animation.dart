import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
// ignore: implementation_imports
import 'package:like_button/src/painter/bubbles_painter.dart';
// ignore: implementation_imports
import 'package:like_button/src/painter/circle_painter.dart';

/// An animation modified from the
/// [package:like_button](https://pub.dev/packages/like_button) package.
class BubbleAnimation extends StatefulWidget {
  const BubbleAnimation({
    required this.builder,
    required this.controller,
    this.size = 20,
    this.bubblesColor,
    this.circleColor,
  })  : bubbleSize = size * 2,
        circleSize = size * .8;

  final WidgetBuilder builder;
  final AnimationController? controller;
  final double size;
  final double bubbleSize;
  final double circleSize;
  final BubblesColor? bubblesColor;
  final CircleColor? circleColor;

  @override
  _BubbleAnimationState createState() => _BubbleAnimationState();
}

class _BubbleAnimationState extends State<BubbleAnimation> {
  late Animation<double> _outerCircleAnimation;
  late Animation<double> _innerCircleAnimation;
  late Animation<double> _bubbleAnimation;

  @override
  void initState() {
    super.initState();

    _outerCircleAnimation = Tween<double>(begin: .1, end: 1).animate(
      CurvedAnimation(
        parent: widget.controller!,
        curve: const Interval(0, .3, curve: Curves.ease),
      ),
    );

    _innerCircleAnimation = Tween<double>(begin: .2, end: 1).animate(
      CurvedAnimation(
        parent: widget.controller!,
        curve: const Interval(.2, .5, curve: Curves.ease),
      ),
    );

    _bubbleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: widget.controller!,
        curve: const Interval(.1, 1, curve: Curves.decelerate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller!,
      builder: (context, child) => Stack(
        clipBehavior: Clip.none,
        children: [
          // bubbles
          Positioned(
            top: (widget.size - widget.bubbleSize) / 2.0,
            left: (widget.size - widget.bubbleSize) / 2.0,
            child: CustomPaint(
              size: Size(widget.bubbleSize, widget.bubbleSize),
              painter: BubblesPainter(
                currentProgress: _bubbleAnimation.value,
                color1: widget.bubblesColor!.dotPrimaryColor,
                color2: widget.bubblesColor!.dotSecondaryColor,
                color3: widget.bubblesColor!.dotThirdColorReal,
                color4: widget.bubblesColor!.dotLastColorReal,
              ),
            ),
          ),

          // circle
          Positioned(
            top: (widget.size - widget.circleSize) / 2,
            left: (widget.size - widget.circleSize) / 2,
            child: CustomPaint(
              size: Size(widget.circleSize, widget.circleSize),
              painter: CirclePainter(
                innerCircleRadiusProgress: _innerCircleAnimation.value,
                outerCircleRadiusProgress: _outerCircleAnimation.value,
                circleColor: widget.circleColor!,
              ),
            ),
          ),

          // child
          widget.builder(context),
        ],
      ),
    );
  }
}
