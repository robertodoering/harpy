import 'package:flutter/material.dart';
import 'package:rby/rby.dart';

class SliverFillLoadingIndicator extends StatelessWidget {
  const SliverFillLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverFillRemaining(
      hasScrollBody: false,
      child: ImmediateOpacityAnimation(
        duration: theme.animation.short,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
