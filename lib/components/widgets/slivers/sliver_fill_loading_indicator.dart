import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class SliverFillLoadingIndicator extends ConsumerWidget {
  const SliverFillLoadingIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: ImmediateOpacityAnimation(
        duration: kShortAnimationDuration,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
