import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/explicit/fade_animation.dart';

/// A loading indicator for a [CustomScrollView].
class SliverFillLoadingIndicator extends StatelessWidget {
  const SliverFillLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: FadeAnimation(
        duration: kShortAnimationDuration,
        curve: Curves.easeInOut,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
