import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// A loading indicator for the beginning or end of a [CustomScrollView].
class SliverBoxLoadingIndicator extends StatelessWidget {
  const SliverBoxLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FadeAnimation(
        duration: kShortAnimationDuration,
        curve: Curves.easeInOut,
        child: Container(
          padding: DefaultEdgeInsets.all(),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
