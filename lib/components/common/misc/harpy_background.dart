import 'package:flutter/material.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds a background with a gradient from top to bottom.
///
/// The [colors] default to the [HarpyTheme.backgroundColors] if omitted.
class HarpyBackground extends StatelessWidget {
  const HarpyBackground({
    this.child,
    this.colors,
    this.borderRadius,
  });

  final Widget child;
  final List<Color> colors;

  /// The [borderRadius] of the [BoxDecoration].
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final List<Color> backgroundColors =
        colors ?? HarpyTheme.of(context).backgroundColors;

    if (backgroundColors.length == 1) {
      // need at least 2 colors for the gradient
      backgroundColors.add(backgroundColors.first);
    }

    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: backgroundColors,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: child ?? Container(),
      ),
    );
  }
}
