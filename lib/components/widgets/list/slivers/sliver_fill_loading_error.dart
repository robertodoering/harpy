import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// A [LoadingDataError] widget for a [CustomScrollView].
///
/// Builds an optional retry button when [onRetry] is not `null`.
class SliverFillLoadingError extends StatelessWidget {
  const SliverFillLoadingError({
    required this.message,
    this.onRetry,
    this.onChangeFilter,
  });

  final Widget message;
  final VoidCallback? onRetry;
  final VoidCallback? onChangeFilter;

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
          onChangeFilter: onChangeFilter,
        ),
      ),
    );
  }
}
