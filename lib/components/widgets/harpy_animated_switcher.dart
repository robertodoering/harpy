import 'package:flutter/material.dart';
import 'package:harpy/core/harpy_theme/harpy_theme.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// Builds an [AnimatedSwitcher] with some predefined defaults.
class HarpyAnimatedSwitcher extends StatelessWidget {
  const HarpyAnimatedSwitcher({
    required this.child,
    this.duration = kShortAnimationDuration,
    this.reverseDuration,
    this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.layoutBuilder = AnimatedSwitcher.defaultLayoutBuilder,
  });

  const HarpyAnimatedSwitcher.sliver({
    required this.child,
    this.duration = kShortAnimationDuration,
    this.reverseDuration,
  })  : transitionBuilder = SliverAnimatedSwitcher.defaultTransitionBuilder,
        layoutBuilder = SliverAnimatedSwitcher.defaultLayoutBuilder;

  final Widget child;
  final Duration duration;
  final Duration? reverseDuration;
  final AnimatedSwitcherTransitionBuilder transitionBuilder;
  final AnimatedSwitcherLayoutBuilder layoutBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: transitionBuilder,
      layoutBuilder: layoutBuilder,
      child: child,
    );
  }
}
