import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Fades and slides the [child] when scrolling down.
///
/// A [ScrollDirectionListener] needs to be built above the list for this widget
/// to retrieve the current [ScrollDirection].
///
/// The animation starts as soon as the [child] becomes visible. The [child] may
/// be built before, depending on the [ScrollView.cacheExtent].
///
/// The [key] is used by the [VisibilityDetector] to determine the [child]
/// visibility and should be the same as the list item.
class ListCardAnimation extends StatefulWidget {
  const ListCardAnimation({
    @required this.child,
    @required Key key,
  }) : super(key: key);

  final Widget child;

  @override
  _ListCardAnimationState createState() => _ListCardAnimationState();
}

class _ListCardAnimationState extends State<ListCardAnimation>
    with SingleTickerProviderStateMixin<ListCardAnimation> {
  ScrollDirection _scrollDirection;
  bool _visible;

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: kLongAnimationDuration,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 150),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // only set the scroll direction once to prevent a change in direction to
    // stop the animation
    if (_scrollDirection == null) {
      _scrollDirection = ScrollDirection.of(context);
      _visible = !_scrollDirection.down;

      if (_scrollDirection.direction == null) {
        // first time building the parent list, animate child
        _visible = true;
        _controller.forward();
      } else if (_scrollDirection.up) {
        // scrolling up, skip animation
        _visible = true;
        _controller.forward(from: 1);
      }
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    // start animation when the child comes into view
    if (!_visible && info.visibleBounds.height > 0) {
      _visible = true;
      if (mounted) {
        _controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key,
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) => FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
