import 'package:flutter/material.dart';
import 'package:rby/rby.dart';
import 'package:shimmer/shimmer.dart';

class SliverLoadingShimmer extends StatelessWidget {
  const SliverLoadingShimmer({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: ImmediateOpacityAnimation(
        duration: theme.animation.short,
        child: Shimmer(
          gradient: LinearGradient(
            colors: [
              theme.cardTheme.color!.withOpacity(.3),
              theme.cardTheme.color!.withOpacity(.3),
              theme.colorScheme.secondary,
              theme.cardTheme.color!.withOpacity(.3),
              theme.cardTheme.color!.withOpacity(.3),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
