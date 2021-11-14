import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

// TODO: remove

/// Builds a transparent scaffold with a [floatingActionButton] that only
/// shows when the [ScrollDirection.direction] matches the [direction].
///
/// A [ScrollDirection] needs to be built above this widget.
class ScrollAwareFloatingActionButton extends StatefulWidget {
  const ScrollAwareFloatingActionButton({
    required this.floatingActionButton,
    required this.child,
    this.direction = VerticalDirection.up,
  });

  final Widget? floatingActionButton;
  final Widget child;

  /// The scroll direction the floating action button should appear on.
  final VerticalDirection direction;

  @override
  _ScrollAwareFloatingActionButtonState createState() =>
      _ScrollAwareFloatingActionButtonState();
}

class _ScrollAwareFloatingActionButtonState
    extends State<ScrollAwareFloatingActionButton> {
  bool _show = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final scrollDirection = ScrollDirection.of(context)!;

    _show = scrollDirection.direction == widget.direction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: _show ? widget.floatingActionButton : null,
      body: widget.child,
    );
  }
}
