import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Fades and slides the [child] when scrolling down or on the initial build if
/// it is visible.
///
/// A [ScrollDirectionListener] needs to be built above the list for this widget
/// to retrieve the current [ScrollDirection].
///
/// A [VisibilityChangeDetector] needs to be built above the list, or
/// [buildVisibilityChangeDetector] needs to be `true` for this widget to build
/// its own [VisibilityChangeDetector].
///
/// The animation starts as soon as the [child] becomes visible.
///
/// When the performance mode option is enabled, [ListCardAnimation] will simply
/// build the [child] without any animation.
class ListCardAnimation extends StatefulWidget {
  const ListCardAnimation({
    required this.child,
    Key? key,
    this.buildVisibilityChangeDetector = true,
  })  : assert(
          !buildVisibilityChangeDetector ||
              buildVisibilityChangeDetector && key != null,
        ),
        super(key: key);

  final Widget child;

  /// Whether this widget should build its own [VisibilityChangeDetector].
  ///
  /// [key] must not be `null` when [buildVisibilityChangeDetector] is `true`.
  final bool buildVisibilityChangeDetector;

  @override
  _ListCardAnimationState createState() => _ListCardAnimationState();
}

class _ListCardAnimationState extends State<ListCardAnimation>
    with SingleTickerProviderStateMixin<ListCardAnimation> {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  VisibilityChange? _visibilityChange;

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
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!widget.buildVisibilityChangeDetector) {
      _visibilityChange = VisibilityChange.of(context);

      assert(_visibilityChange != null);

      _visibilityChange?.addOnVisibilityChanged(
        _onVisibilityChanged,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    if (!widget.buildVisibilityChangeDetector) {
      _visibilityChange?.removeOnVisibilityChanged(
        _onVisibilityChanged,
      );
    }

    super.dispose();
  }

  void _onVisibilityChanged(bool visible) {
    if (visible) {
      final scrollDirection = ScrollDirection.of(context);

      if (scrollDirection?.direction == null || scrollDirection!.down) {
        // first time building the parent list or scrolling down, animate child
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if (mounted) {
            // start the controller after one frame to prevent issues when
            // animation plays during navigation
            _controller.forward(from: 0);
          }
        });
      } else {
        // scrolling up, skip animation
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if (mounted) {
            _controller.forward(from: 1);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (app<GeneralPreferences>().performanceMode) {
      return widget.child;
    } else if (widget.buildVisibilityChangeDetector) {
      return VisibilityChangeDetector(
        key: widget.key,
        onVisibilityChanged: _onVisibilityChanged,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.translate(
              offset: _slideAnimation.value,
              child: widget.child,
            ),
          ),
        ),
      );
    } else {
      return AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: widget.child,
          ),
        ),
      );
    }
  }
}
