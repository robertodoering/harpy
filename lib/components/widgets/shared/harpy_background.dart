import 'package:flutter/material.dart';
import 'package:harpy/models/theme_model.dart';

/// Builds a background with a gradient from [begin] to [end] in the
/// [startColor] and [endColor].
class HarpyBackground extends StatelessWidget {
  const HarpyBackground({
    this.child,
    this.borderRadius,
    this.begin = Alignment.topRight,
    this.end = Alignment.bottomLeft,
    this.startColor,
    this.endColor,
  });

  final Widget child;
  final BorderRadiusGeometry borderRadius;

  final Alignment begin;
  final Alignment end;
  final Color startColor;
  final Color endColor;

  @override
  Widget build(BuildContext context) {
    final harpyTheme = ThemeModel.of(context).harpyTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: [
            startColor ?? harpyTheme.primaryBackgroundColor,
            endColor ?? harpyTheme.secondaryBackgroundColor,
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: child ?? Container(),
      ),
    );
  }
}
