import 'package:flutter/material.dart';
import 'package:harpy/core/harpy_theme/harpy_theme.dart';

/// Builds an [AnimatedSwitcher] with some predefined defaults.
class HarpyAnimatedSwitcher extends StatelessWidget {
  const HarpyAnimatedSwitcher({
    required this.child,
    this.duration = kShortAnimationDuration,
    this.reverseDuration,
    this.layoutBuilder = AnimatedSwitcher.defaultLayoutBuilder,
  });

  final Widget child;
  final Duration duration;
  final Duration? reverseDuration;
  final AnimatedSwitcherLayoutBuilder layoutBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      layoutBuilder: layoutBuilder,
      child: child,
    );
  }
}
