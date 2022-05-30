import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

/// A loading indicator for the beginning or end of a [CustomScrollView].
class SliverLoadingIndicator extends ConsumerWidget {
  const SliverLoadingIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return SliverToBoxAdapter(
      child: ImmediateOpacityAnimation(
        duration: kShortAnimationDuration,
        child: Container(
          padding: display.edgeInsets,
          alignment: AlignmentDirectional.center,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
