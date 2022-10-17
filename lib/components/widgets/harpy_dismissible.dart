import 'package:flutter/material.dart';
import 'package:rby/rby.dart';

const _threshold = .05;

/// A widget used to dismiss its [child].
///
/// Similar to [Dismissible] with some adjustments.
class HarpyDismissible extends StatefulWidget {
  const HarpyDismissible({
    required this.child,
    this.onDismissed,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onDismissed;
  final bool enabled;

  @override
  State<HarpyDismissible> createState() => _HarpyDismissibleState();
}

class _HarpyDismissibleState extends State<HarpyDismissible>
    with SingleTickerProviderStateMixin {
  late AnimationController _moveController;
  Animation<Offset>? _moveAnimation;

  double _dragExtent = 0;
  bool _dragUnderway = false;

  bool get _isActive => _dragUnderway || _moveController.isAnimating;

  @override
  void initState() {
    super.initState();

    _moveController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _updateMoveAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _moveController.duration = Theme.of(context).animation.long;
  }

  @override
  void dispose() {
    _moveController.dispose();

    super.dispose();
  }

  void _updateMoveAnimation() {
    final end = _dragExtent.sign;

    _moveAnimation = _moveController.drive(
      Tween(
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
    if (!_isActive || _moveController.isAnimating) return;

    final delta = details.primaryDelta;
    if (delta == null) return;

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
    if (!_isActive || _moveController.isAnimating) return;

    _dragUnderway = false;

    if (_moveController.isCompleted) return;

    if (!_moveController.isDismissed) {
      // if the dragged value exceeded the dismissThreshold, call onDismissed
      // else animate back to initial position.
      if (_moveController.value > _threshold) {
        widget.onDismissed?.call();
      } else {
        _moveController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: widget.enabled ? _handleDragStart : null,
      onVerticalDragUpdate: widget.enabled ? _handleDragUpdate : null,
      onVerticalDragEnd: widget.enabled ? _handleDragEnd : null,
      child: SlideTransition(
        position: _moveAnimation ?? const AlwaysStoppedAnimation(Offset.zero),
        child: widget.child,
      ),
    );
  }
}
