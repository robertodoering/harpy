import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/rby/rby.dart';

class ListCardAnimation extends ConsumerStatefulWidget {
  const ListCardAnimation({
    required this.child,
  });

  final Widget child;

  @override
  _ListCardAnimationState createState() => _ListCardAnimationState();
}

class _ListCardAnimationState extends ConsumerState<ListCardAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  VisibilityChange? _visibilityChange;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeAnimation = CurveTween(
      curve: const Interval(0, .5, curve: Curves.easeOut),
    ).animate(_controller);

    _scaleAnimation = Tween<double>(begin: .95, end: 1)
        .chain(CurveTween(curve: Curves.easeOutCubic))
        .animate(_controller);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _visibilityChange ??= VisibilityChange.of(context)
      ?..addCallback(_onVisibilityChanged);

    assert(_visibilityChange != null);
  }

  @override
  void dispose() {
    _controller.dispose();
    _visibilityChange?.removeCallback(_onVisibilityChanged);

    super.dispose();
  }

  void _onVisibilityChanged(bool visible) {
    if (mounted && visible) {
      final scrollDirection = UserScrollDirection.scrollDirectionOf(context);

      if (scrollDirection != ScrollDirection.forward) {
        // idle or scrolling down
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          // start the controller after one frame to prevent issues when
          // animation plays during navigation
          if (mounted) _controller.forward(from: 0);
        });
      } else {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          // scrolling up, skip animation
          if (mounted) _controller.forward(from: 1);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final general = ref.watch(generalPreferencesProvider);

    return general.performanceMode
        ? widget.child
        : AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                alignment: Alignment.bottomCenter,
                child: widget.child,
              ),
            ),
          );
  }
}
