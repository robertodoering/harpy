import 'package:flutter/material.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';

/// Builds a transparent scaffold with a [floatingActionButton] that only
/// shows when the [ScrollDirection.direction] matches the [direction].
///
/// A [ScrollDirection] needs to be built above this widget.
class ScrollAwareFloatingActionButton extends StatefulWidget {
  const ScrollAwareFloatingActionButton({
    @required this.floatingActionButton,
    @required this.child,
    this.direction = VerticalDirection.up,
  }) : assert(direction != null);

  final Widget floatingActionButton;
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

    final ScrollDirection scrollDirection = ScrollDirection.of(context);
    assert(scrollDirection != null);

    _show = ScrollDirection.of(context)?.direction == widget.direction;
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
