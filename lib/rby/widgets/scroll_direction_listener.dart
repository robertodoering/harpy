import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Listens to [UserScrollNotification] that bubble up the tree to expose
/// changes to the [ScrollDirection] to its children.
///
/// Only changes in the [ScrollDirection.forward] and [ScrollDirection.reverse]
/// direction are listened to.
class ScrollDirectionListener extends StatefulWidget {
  const ScrollDirectionListener({
    required this.child,
    this.depth,
  });

  final Widget child;

  /// The depth of the scroll notification this listener should listen for.
  ///
  /// Useful when multiple scroll views are built below the listener (e.g.
  /// when using a [NestedScrollView]).
  ///
  /// Listens to every scroll notification regardless of depth when `null`.
  final int? depth;

  @override
  _ScrollDirectionListenerState createState() =>
      _ScrollDirectionListenerState();
}

class _ScrollDirectionListenerState extends State<ScrollDirectionListener> {
  ScrollDirection _direction = ScrollDirection.idle;

  bool _onNotification(UserScrollNotification notification) {
    if (widget.depth != null && notification.depth != widget.depth) {
      return false;
    }

    if (mounted &&
        notification.direction != ScrollDirection.idle &&
        _direction != notification.direction) {
      setState(() => _direction = notification.direction);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: _onNotification,
      child: UserScrollDirection(
        direction: _direction,
        child: widget.child,
      ),
    );
  }
}

/// Inherited widget to provide the current [ScrollDirection] to its children.
class UserScrollDirection extends InheritedWidget {
  const UserScrollDirection({
    required Widget child,
    required this.direction,
  }) : super(child: child);

  final ScrollDirection direction;

  static ScrollDirection? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<UserScrollDirection>()
        ?.direction;
  }

  @override
  bool updateShouldNotify(covariant UserScrollDirection oldWidget) {
    return oldWidget.direction != direction;
  }
}
