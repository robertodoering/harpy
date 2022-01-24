import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:shimmer/shimmer.dart';

/// A [SliverToBoxAdapter] that displays the [child] in a [Shimmer] animation.
class SliverBoxLoadingShimmer extends StatelessWidget {
  const SliverBoxLoadingShimmer({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: FadeAnimation(
        duration: kShortAnimationDuration,
        curve: Curves.easeInOut,
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
