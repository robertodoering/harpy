import 'dart:math' as math;

import 'package:flutter/material.dart';

@immutable
class BubblesColor {
  const BubblesColor({
    required this.primary,
    required this.secondary,
    Color? tertiary,
    Color? quaternary,
  })  : tertiary = tertiary ?? primary,
        quaternary = quaternary ?? secondary;

  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color quaternary;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BubblesColor &&
        other.primary == primary &&
        other.secondary == secondary &&
        other.tertiary == tertiary &&
        other.quaternary == quaternary;
  }

  @override
  int get hashCode => Object.hash(
        primary,
        secondary,
        tertiary,
        quaternary,
      );
}

@immutable
class CircleColor {
  const CircleColor({
    required this.start,
    required this.end,
  });

  final Color start;
  final Color end;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircleColor && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start.hashCode, end.hashCode);
}

/// An animation modified from the
/// [package:like_button](https://pub.dev/packages/like_button) package.
class BubbleAnimation extends StatefulWidget {
  const BubbleAnimation({
    required this.builder,
    required this.controller,
    this.size,
    this.bubblesColor = defaultBubblesColor,
    this.circleColor = defaultCircleColor,
  });

  final WidgetBuilder builder;
  final AnimationController controller;
  final double? size;

  final BubblesColor bubblesColor;
  final CircleColor circleColor;

  static const defaultBubblesColor = BubblesColor(
    primary: Color(0xFFFFC107),
    secondary: Color(0xFFFF9800),
    tertiary: Color(0xFFFF5722),
    quaternary: Color(0xFFF44336),
  );

  static const defaultCircleColor = CircleColor(
    start: Color(0xFFFF5722),
    end: Color(0xFFFFC107),
  );

  @override
  State<BubbleAnimation> createState() => _BubbleAnimationState();
}

class _BubbleAnimationState extends State<BubbleAnimation> {
  late Animation<double> _outerCircleAnimation;
  late Animation<double> _innerCircleAnimation;
  late Animation<double> _bubbleAnimation;

  @override
  void initState() {
    super.initState();

    _outerCircleAnimation = Tween<double>(begin: .1, end: 1)
        .chain(CurveTween(curve: const Interval(0, .3, curve: Curves.ease)))
        .animate(widget.controller);

    _innerCircleAnimation = Tween<double>(begin: .2, end: 1)
        .chain(CurveTween(curve: const Interval(.2, .5, curve: Curves.ease)))
        .animate(widget.controller);

    _bubbleAnimation = Tween<double>(begin: 0, end: 1)
        .chain(
          CurveTween(curve: const Interval(.1, 1, curve: Curves.decelerate)),
        )
        .animate(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? IconTheme.of(context).size!;
    final bubbleSize = size * 2;
    final circleSize = size * .8;

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) => Stack(
        clipBehavior: Clip.none,
        children: [
          // bubbles
          PositionedDirectional(
            top: (size - bubbleSize) / 2.0,
            start: (size - bubbleSize) / 2.0,
            child: CustomPaint(
              size: Size(bubbleSize, bubbleSize),
              painter: _BubblesPainter(
                currentProgress: _bubbleAnimation.value,
                bubblesColor: widget.bubblesColor,
              ),
            ),
          ),

          // circle
          PositionedDirectional(
            top: (size - circleSize) / 2,
            start: (size - circleSize) / 2,
            child: CustomPaint(
              size: Size(circleSize, circleSize),
              painter: _CirclePainter(
                innerCircleRadiusProgress: _innerCircleAnimation.value,
                outerCircleRadiusProgress: _outerCircleAnimation.value,
                circleColor: widget.circleColor,
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

class _BubblesPainter extends CustomPainter {
  _BubblesPainter({
    required this.currentProgress,
    required this.bubblesColor,
  }) {
    _outerBubblesPositionAngle = 36.0 / _bubblesCount;

    _circlePaints = List.filled(4, Paint()..style = PaintingStyle.fill);
  }

  final double currentProgress;
  final BubblesColor bubblesColor;

  late final double _outerBubblesPositionAngle;
  late final List<Paint> _circlePaints;

  double _maxOuterDotsRadius = 0;
  double _maxInnerDotsRadius = 0;
  double _maxDotSize = 0;

  double _currentRadius1 = 0;
  double _currentDotSize1 = 0;
  double _currentDotSize2 = 0;
  double _currentRadius2 = 0;

  static const _bubblesCount = 7;

  @override
  void paint(Canvas canvas, Size size) {
    _maxDotSize = size.width * .05;
    _maxOuterDotsRadius = size.width * .5 - _maxDotSize * 2;
    _maxInnerDotsRadius = .8 * _maxOuterDotsRadius;

    _updateOuterBubblesPosition();
    _updateInnerBubblesPosition();
    _updateBubblesPaints();
    _drawOuterBubblesFrame(canvas, size);
    _drawInnerBubblesFrame(canvas, size);
  }

  void _updateOuterBubblesPosition() {
    if (currentProgress < .3) {
      _currentRadius1 = _mapRange(
        currentProgress,
        fromLow: 0,
        fromHigh: .3,
        toLow: 0,
        toHigh: _maxOuterDotsRadius * .8,
      );
    } else {
      _currentRadius1 = _mapRange(
        currentProgress,
        fromLow: .3,
        fromHigh: 1,
        toLow: .8 * _maxOuterDotsRadius,
        toHigh: _maxOuterDotsRadius,
      );
    }

    if (currentProgress == 0) {
      _currentDotSize1 = 0;
    } else if (currentProgress < .7) {
      _currentDotSize1 = _maxDotSize;
    } else {
      _currentDotSize1 = _mapRange(
        currentProgress,
        fromLow: .7,
        fromHigh: 1,
        toLow: _maxDotSize,
        toHigh: 0,
      );
    }
  }

  void _updateInnerBubblesPosition() {
    if (currentProgress < .3) {
      _currentRadius2 = _mapRange(
        currentProgress,
        fromLow: 0,
        fromHigh: .3,
        toLow: 0,
        toHigh: _maxInnerDotsRadius,
      );
    } else {
      _currentRadius2 = _maxInnerDotsRadius;
    }

    if (currentProgress == 0) {
      _currentDotSize2 = 0;
    } else if (currentProgress < .2) {
      _currentDotSize2 = _maxDotSize;
    } else if (currentProgress < .5) {
      _currentDotSize2 = _mapRange(
        currentProgress,
        fromLow: .2,
        fromHigh: .5,
        toLow: _maxDotSize,
        toHigh: .3 * _maxDotSize,
      );
    } else {
      _currentDotSize2 = _mapRange(
        currentProgress,
        fromLow: .5,
        fromHigh: 1,
        toLow: _maxDotSize * .3,
        toHigh: 0,
      );
    }
  }

  void _updateBubblesPaints() {
    final progress = currentProgress.clamp(.6, 1.0);
    final alpha = _mapRange(
      progress,
      fromLow: .6,
      fromHigh: 1,
      toLow: 255,
      toHigh: 0,
    ).toInt();

    if (currentProgress < .5) {
      final progress = _mapRange(
        currentProgress,
        fromLow: 0,
        fromHigh: .5,
        toLow: 0,
        toHigh: 1,
      );

      _circlePaints[0].color =
          Color.lerp(bubblesColor.primary, bubblesColor.secondary, progress)!
              .withAlpha(alpha);

      _circlePaints[1].color =
          Color.lerp(bubblesColor.secondary, bubblesColor.tertiary, progress)!
              .withAlpha(alpha);

      _circlePaints[2].color =
          Color.lerp(bubblesColor.tertiary, bubblesColor.quaternary, progress)!
              .withAlpha(alpha);

      _circlePaints[3].color =
          Color.lerp(bubblesColor.quaternary, bubblesColor.primary, progress)!
              .withAlpha(alpha);
    } else {
      final progress = _mapRange(
        currentProgress,
        fromLow: .5,
        fromHigh: 1,
        toLow: 0,
        toHigh: 1,
      );

      _circlePaints[0].color =
          Color.lerp(bubblesColor.secondary, bubblesColor.tertiary, progress)!
              .withAlpha(alpha);

      _circlePaints[1].color =
          Color.lerp(bubblesColor.tertiary, bubblesColor.quaternary, progress)!
              .withAlpha(alpha);

      _circlePaints[2].color =
          Color.lerp(bubblesColor.quaternary, bubblesColor.primary, progress)!
              .withAlpha(alpha);

      _circlePaints[3].color =
          Color.lerp(bubblesColor.primary, bubblesColor.secondary, progress)!
              .withAlpha(alpha);
    }
  }

  void _drawOuterBubblesFrame(Canvas canvas, Size size) {
    final start = _outerBubblesPositionAngle / 4 * 3;

    for (var i = 0; i < _bubblesCount; i++) {
      final cX = size.width / 2 +
          _currentRadius1 *
              math.cos((start + _outerBubblesPositionAngle * i).toRad);

      final cY = size.height / 2 +
          _currentRadius1 *
              math.sin((start + _outerBubblesPositionAngle * i).toRad);

      canvas.drawCircle(
        Offset(cX, cY),
        _currentDotSize1,
        _circlePaints[i % _circlePaints.length],
      );
    }
  }

  void _drawInnerBubblesFrame(Canvas canvas, Size size) {
    final start = _outerBubblesPositionAngle / 4.0 * 3.0 -
        _outerBubblesPositionAngle / 2.0;

    for (var i = 0; i < _bubblesCount; i++) {
      final cX = size.width / 2 +
          _currentRadius2 *
              math.cos((start + _outerBubblesPositionAngle * i).toRad);

      final cY = size.height / 2 +
          _currentRadius2 *
              math.sin((start + _outerBubblesPositionAngle * i).toRad);

      canvas.drawCircle(
        Offset(cX, cY),
        _currentDotSize2,
        _circlePaints[(i + 1) % _circlePaints.length],
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BubblesPainter oldDelegate) {
    return oldDelegate.currentProgress != currentProgress ||
        oldDelegate.bubblesColor != bubblesColor;
  }
}

class _CirclePainter extends CustomPainter {
  _CirclePainter({
    required this.outerCircleRadiusProgress,
    required this.innerCircleRadiusProgress,
    required this.circleColor,
  }) {
    _circlePaint = Paint()..style = PaintingStyle.stroke;

    _circlePaint.color = Color.lerp(
      circleColor.start,
      circleColor.end,
      _mapRange(
        outerCircleRadiusProgress.clamp(.5, 1),
        fromLow: .5,
        fromHigh: 1,
        toLow: 0,
        toHigh: 1,
      ),
    )!;
  }

  final double outerCircleRadiusProgress;
  final double innerCircleRadiusProgress;
  final CircleColor circleColor;
  late final Paint _circlePaint;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.width * .5;

    final strokeWidth = outerCircleRadiusProgress * center -
        (innerCircleRadiusProgress * center);

    if (strokeWidth > 0) {
      _circlePaint.strokeWidth = strokeWidth;

      canvas.drawCircle(
        Offset(center, center),
        outerCircleRadiusProgress * center,
        _circlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.outerCircleRadiusProgress != outerCircleRadiusProgress ||
        oldDelegate.innerCircleRadiusProgress != innerCircleRadiusProgress ||
        oldDelegate.circleColor != circleColor;
  }
}

extension on num {
  num get toRad => this * (math.pi / 18.0);
}

double _mapRange(
  double value, {
  required double fromLow,
  required double fromHigh,
  required double toLow,
  required double toHigh,
}) {
  return toLow + ((value - fromLow) / (fromHigh - fromLow) * (toHigh - toLow));
}
