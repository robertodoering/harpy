import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rby/rby.dart';

class SliverFillLoadingIndicator extends ConsumerWidget {
  const SliverFillLoadingIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
