import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// A [LoadingError] widget as a sliver that fills the remaining space in the
/// viewport.
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
      child: LoadingError(
        message: message,
        onRetry: onRetry,
        onChangeFilter: onChangeFilter,
      ),
    );
  }
}
