import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';

/// Scroll direction changes will only be updated if the affected scroll view
/// has a `maxScrollExtent` of this threshold.
const _maxScrollExtentThreshold = 200;

/// Scroll direction changes will only be applied if the affected scroll view
/// has scrolled through this amount of pixels after changing scroll direction.
const _scrollDirectionThreshold = 15;

/// Listens to [UserScrollNotification] that bubble up the tree to expose
/// changes to the [ScrollDirection] to its children.
///
/// Only changes in the [ScrollDirection.forward] and [ScrollDirection.reverse]
/// direction are listened to.
class ScrollDirectionListener extends ConsumerStatefulWidget {
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
  ConsumerState<ScrollDirectionListener> createState() =>
      _ScrollDirectionListenerState();
}

class _ScrollDirectionListenerState
    extends ConsumerState<ScrollDirectionListener> with RouteAware {
  RouteObserver? _observer;

  /// Last known scroll position.
  double _scrollValue = 0;

  /// Position at which scroll direction changed.
  double _scrollStart = 0;

  /// Last scroll direction known to the listeners.
  ScrollDirection _direction = ScrollDirection.idle;

  /// Direction in which the user is currently scrolling.
  /// May be different from [_direction] due to [_scrollDirectionThreshold].
  ScrollDirection _directionInterim = ScrollDirection.idle;

  // Assume scrolling up when a new route gets popped / pushed onto the screen.
  // This is a workaround for scroll direction sensitive animations to prevent
  // a repeating animation when the next route gets popped and the animated
  // widget become visible again.
  @override
  void didPopNext() => _set(ScrollDirection.forward);

  @override
  void didPushNext() => _set(ScrollDirection.forward);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _observer ??= ref.read(routeObserver)
      ?..subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _observer?.unsubscribe(this);

    super.dispose();
  }

  bool _onNotification(ScrollNotification notification) {
    if (widget.depth != null && notification.depth != widget.depth) {
      return false;
    }

    final metrics = notification.metrics;

    if (mounted && metrics.maxScrollExtent > _maxScrollExtentThreshold) {
      final scrollValue = metrics.pixels;
      final scrollDirection = scrollValue == 0 || scrollValue - _scrollValue < 0
          ? ScrollDirection.forward
          : ScrollDirection.reverse;

      if (_directionInterim != scrollDirection) {
        _directionInterim = scrollDirection;
        _scrollStart = scrollValue;
      }

      if (_direction != scrollDirection) {
        if ((scrollValue - _scrollStart).abs() > _scrollDirectionThreshold) {
          _set(scrollDirection);
        }
      }

      _scrollValue = scrollValue;
    }

    return false;
  }

  void _set(ScrollDirection direction) {
    if (mounted) setState(() => _direction = direction);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: UserScrollDirection(
        direction: _direction,
        idle: () => _set(ScrollDirection.idle),
        forward: () => _set(ScrollDirection.forward),
        reverse: () => _set(ScrollDirection.reverse),
        child: widget.child,
      ),
    );
  }
}

/// Inherited widget to provide the current [ScrollDirection] to its children.
class UserScrollDirection extends InheritedWidget {
  const UserScrollDirection({
    required super.child,
    required this.direction,
    required this.idle,
    required this.reverse,
    required this.forward,
  });

  final ScrollDirection direction;
  final VoidCallback idle;
  final VoidCallback reverse;
  final VoidCallback forward;

  static UserScrollDirection? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserScrollDirection>();
  }

  static ScrollDirection? scrollDirectionOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<UserScrollDirection>()
        ?.direction;
  }

  @override
  bool updateShouldNotify(covariant UserScrollDirection oldWidget) {
    return oldWidget.direction != direction;
  }
}
