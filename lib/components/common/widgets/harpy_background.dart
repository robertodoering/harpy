import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HarpyBackground extends ConsumerWidget {
  const HarpyBackground({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);
    final colors = harpyTheme.colors.backgroundColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.length == 1 ? colors.single : null,
        gradient: colors.length > 1
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: colors.toList(),
              )
            : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}
