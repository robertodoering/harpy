import 'package:flutter/material.dart';
import 'package:rby/rby.dart';

/// A loading indicator for the beginning or end of a [CustomScrollView].
class SliverLoadingIndicator extends StatelessWidget {
  const SliverLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: ImmediateOpacityAnimation(
        duration: theme.animation.short,
        child: Container(
          padding: theme.spacing.edgeInsets,
          alignment: AlignmentDirectional.center,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
