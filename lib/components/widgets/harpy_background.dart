import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class HarpyBackground extends ConsumerWidget {
  const HarpyBackground({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final colors = harpyTheme.colors.backgroundColors;

    return AnimatedContainer(
      duration: theme.animation.short,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
          colors: colors.length == 1
              ? List.filled(2, colors.single)
              : colors.toList(),
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}
