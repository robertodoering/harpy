import 'package:flutter/material.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';

/// Builds a background with a gradient from top to bottom.
///
/// The [colors] default to the [HarpyTheme.backgroundColors] if omitted.
class HarpyBackground extends StatelessWidget {
  const HarpyBackground({
    this.child,
    this.colors,
  });

  final Widget child;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final harpyTheme = ThemeSettingsModel.of(context).harpyTheme;

    final backgroundColors = colors ?? harpyTheme.backgroundColors;

    if (backgroundColors.length == 1) {
      backgroundColors.add(backgroundColors.first);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors ?? harpyTheme.backgroundColors,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: child ?? Container(),
      ),
    );
  }
}
