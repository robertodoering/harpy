import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds a background with a gradient from top to bottom.
///
/// The [colors] default to the [HarpyTheme.backgroundColors] if omitted.
class HarpyBackground extends StatelessWidget {
  const HarpyBackground({
    this.child,
    this.colors,
    this.borderRadius,
  });

  final Widget? child;
  final List<Color>? colors;

  /// The [borderRadius] of the [BoxDecoration].
  final BorderRadius? borderRadius;

  LinearGradient _buildGradient(List<Color> backgroundColors) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: backgroundColors.length > 1
          ? backgroundColors
          : <Color>[
              backgroundColors.first,
              backgroundColors.first,
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> backgroundColors =
        colors ?? HarpyTheme.of(context).backgroundColors;

    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: _buildGradient(backgroundColors),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: child ?? Container(),
      ),
    );
  }
}
