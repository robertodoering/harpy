import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// A widget used to dismiss its [child].
///
/// Similar to [Dismissible] with some adjustments.
class CustomDismissible extends StatefulWidget {
  const CustomDismissible({
    required this.child,
    this.onDismissed,
    this.dismissThreshold = 0.05,
    this.enabled = true,
  });

  final Widget child;
  final double dismissThreshold;
  final VoidCallback? onDismissed;
  final bool enabled;

  @override
  _CustomDismissibleState createState() => _CustomDismissibleState();
}

class _CustomDismissibleState extends State<CustomDismissible>
    with SingleTickerProviderStateMixin {
  late AnimationController _moveController;
  late Animation<Offset> _moveAnimation;

  double _dragExtent = 0;
  bool _dragUnderway = false;

  bool get _isActive => _dragUnderway || _moveController.isAnimating;

  @override
  void initState() {
    super.initState();

    _moveController = AnimationController(
      duration: kLongAnimationDuration,
      vsync: this,
    );

    _updateMoveAnimation();
  }

  @override
  void dispose() {
    _moveController.dispose();

    super.dispose();
  }

  void _updateMoveAnimation() {
    final end = _dragExtent.sign;

    _moveAnimation = _moveController.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0, end),
      ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    _dragUnderway = true;

    if (_moveController.isAnimating) {
      _dragExtent =
          _moveController.value * context.size!.height * _dragExtent.sign;
      _moveController.stop();
    } else {
      _dragExtent = 0.0;
      _moveController.value = 0.0;
    }
    setState(_updateMoveAnimation);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isActive || _moveController.isAnimating) {
      return;
    }

    final delta = details.primaryDelta!;
    final oldDragExtent = _dragExtent;

    if (_dragExtent + delta < 0) {
      _dragExtent += delta;
    } else if (_dragExtent + delta > 0) {
      _dragExtent += delta;
    }

    if (oldDragExtent.sign != _dragExtent.sign) {
      setState(_updateMoveAnimation);
    }

    if (!_moveController.isAnimating) {
      _moveController.value = _dragExtent.abs() / context.size!.height;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isActive || _moveController.isAnimating) {
      return;
    }

    _dragUnderway = false;

    if (_moveController.isCompleted) {
      return;
    }

    if (!_moveController.isDismissed) {
      // if the dragged value exceeded the dismissThreshold, call onDismissed
      // else animate back to initial position.
      if (_moveController.value > widget.dismissThreshold) {
        widget.onDismissed?.call();
      } else {
        _moveController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = SlideTransition(
      position: _moveAnimation,
      child: widget.child,
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: widget.enabled ? _handleDragStart : null,
      onVerticalDragUpdate: widget.enabled ? _handleDragUpdate : null,
      onVerticalDragEnd: widget.enabled ? _handleDragEnd : null,
      child: content,
    );
  }
}
