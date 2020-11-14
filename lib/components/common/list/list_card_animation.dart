import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/list/visibility_change_detector.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Fades and slides the [child] when scrolling down or on the initial build if
/// it is visible.
///
/// A [ScrollDirectionListener] needs to be built above the list for this widget
/// to retrieve the current [ScrollDirection].
///
/// The animation starts as soon as the [child] becomes visible. The [child] may
/// be built before, depending on the [ScrollView.cacheExtent].
///
/// The [key] is used by the [VisibilityDetector] to determine the [child]'s
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
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: kShortAnimationDuration,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 150),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
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

  void _onVisibilityChanged(bool visible) {
    if (visible) {
      final ScrollDirection scrollDirection = ScrollDirection.of(context);

      if (scrollDirection.direction == null || scrollDirection.down) {
        // first time building the parent list or scrolling down, animate child
        if (mounted) {
          _controller.forward(from: 0);
        }
      } else {
        // scrolling up, skip animation
        if (mounted) {
          _controller.forward(from: 1);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityChangeDetector(
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
