import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/animations/animation_constants.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:shimmer/shimmer.dart';

/// A [SliverToBoxAdapter] that displays the [child] in a [Shimmer] animation.
class SliverBoxLoadingShimmer extends StatelessWidget {
  const SliverBoxLoadingShimmer({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: FadeAnimation(
        duration: kShortAnimationDuration,
        curve: Curves.easeInOut,
        child: Shimmer.fromColors(
          baseColor: theme.cardTheme.color!.withOpacity(.3),
          highlightColor: theme.colorScheme.secondary,
          child: child,
        ),
      ),
    );
  }
}
