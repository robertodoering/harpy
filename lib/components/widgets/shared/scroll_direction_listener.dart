import 'package:flutter/material.dart';

/// A callback used by the [ScrollDirectionListener] that is invoked when the
/// scroll direction changes.
typedef OnScrollDirectionChanged = void Function(VerticalDirection direction);

/// A widget that listens to [ScrollNotification]s that bubble up the tree and
/// invokes the [onScrollDirectionChanged] callback whenever the scroll
/// direction changes.
///
/// The [ScrollDirectionListener] needs to be above the scrollable element in
/// the widget tree.
///
/// A [ScrollDirection] is built above the [child] that inherits the scroll
/// direction to its children.
class ScrollDirectionListener extends StatefulWidget {
  const ScrollDirectionListener({
    @required this.child,
    this.onScrollDirectionChanged,
  });

  final Widget child;

  /// The callback that is invoked whenever the scroll direction changes.
  final OnScrollDirectionChanged onScrollDirectionChanged;

  @override
  _ScrollDirectionListenerState createState() =>
      _ScrollDirectionListenerState();
}

class _ScrollDirectionListenerState extends State<ScrollDirectionListener> {
  double _lastPosition = 0;
  VerticalDirection _direction;

  void _changeDirection(VerticalDirection direction) {
    if (_direction != direction) {
      setState(() {
        _direction = direction;
      });

      if (widget.onScrollDirectionChanged != null) {
        widget.onScrollDirectionChanged(direction);
      }
    }
  }

  bool _onNotification(ScrollNotification notification) {
    final scrollPosition = notification.metrics.pixels;

    if (_lastPosition < scrollPosition) {
      // scrolling down
      _changeDirection(VerticalDirection.down);
    } else if (_lastPosition > scrollPosition) {
      // scrolling up
      _changeDirection(VerticalDirection.up);
    }

    _lastPosition = scrollPosition;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: ScrollDirection(
        direction: _direction,
        child: widget.child,
      ),
    );
  }
}

/// An [InheritedWidget] used by the [ScrollDirectionListener] to provide the
/// current scroll direction to its children.
///
/// The [direction] is `null` until the first [ScrollNotification] gets
/// received.
class ScrollDirection extends InheritedWidget {
  const ScrollDirection({
    @required this.direction,
    @required Widget child,
    Key key,
  })  : assert(child != null),
        super(key: key, child: child);

  final VerticalDirection direction;

  /// `true` when the user is scrolling up (or left if the axis is horizontal).
  bool get up => direction == VerticalDirection.up;
  bool get left => up;

  /// `true` when the user is scrolling down (or right if the axis is
  /// horizontal).
  bool get down => direction == VerticalDirection.down;
  bool get right => down;

  static ScrollDirection of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ScrollDirection)
        as ScrollDirection;
  }

  @override
  bool updateShouldNotify(ScrollDirection old) {
    return old.direction != direction;
  }
}
