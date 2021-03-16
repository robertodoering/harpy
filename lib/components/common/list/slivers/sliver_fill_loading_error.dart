import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/explicit/fade_animation.dart';
import 'package:harpy/components/common/api/loading_data_error.dart';

/// A [LoadingDataError] widget for a [CustomScrollView].
///
/// Builds an optional retry button when [onRetry] is not `null`.
class SliverFillLoadingError extends StatelessWidget {
  const SliverFillLoadingError({
    @required this.message,
    this.onRetry,
    this.onClearFilter,
  });

  final Widget message;
  final VoidCallback onRetry;
  final VoidCallback onClearFilter;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: FadeAnimation(
        duration: kShortAnimationDuration,
        curve: Curves.easeInOut,
        child: LoadingDataError(
          message: message,
          onRetry: onRetry,
          onClearFilter: onClearFilter,
        ),
      ),
    );
  }
}
