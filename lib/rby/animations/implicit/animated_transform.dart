import 'package:flutter/widgets.dart';

/// Implicitly animated [Transform].
///
/// Automatically transitions the child's [transform] over a given [duration].
class AnimatedTransform extends ImplicitlyAnimatedWidget {
  const AnimatedTransform({
    required this.child,
    required super.duration,
    required this.transform,
    super.curve = Curves.easeInOut,
  });

  AnimatedTransform.translate({
    required this.child,
    required super.duration,
    required Offset offset,
    super.curve = Curves.easeInOut,
  }) : transform = Matrix4.translationValues(offset.dx, offset.dy, 0);

  final Widget child;
  final Matrix4 transform;

  @override
  ImplicitlyAnimatedWidgetState<AnimatedTransform> createState() =>
      _AnimatedTranslateState();
}

class _AnimatedTranslateState
    extends ImplicitlyAnimatedWidgetState<AnimatedTransform> {
  Matrix4Tween? _matrix;
  late Animation<Matrix4> _transformAnimation;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _matrix = visitor(
      _matrix,
      widget.transform,
      (value) => Matrix4Tween(begin: value as Matrix4),
    ) as Matrix4Tween?;
  }

  @override
  void didUpdateTweens() {
    _transformAnimation = animation.drive(_matrix!);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _transformAnimation,
      builder: (_, __) => Transform(
        transform: _transformAnimation.value,
        child: widget.child,
      ),
    );
  }
}
