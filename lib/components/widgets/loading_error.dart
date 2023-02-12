import 'package:flutter/material.dart';
import 'package:rby/rby.dart';

/// Builds an error message that fades into view. with optional actions.
class LoadingError extends StatelessWidget {
  const LoadingError({
    required this.message,
    this.onRetry,
    this.onChangeFilter,
  });

  final Widget message;
  final VoidCallback? onRetry;
  final VoidCallback? onChangeFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ImmediateOpacityAnimation(
      duration: theme.animation.short,
      child: Container(
        padding: theme.spacing.edgeInsets,
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextStyle(
              style: theme.textTheme.titleLarge!,
              textAlign: TextAlign.center,
              child: message,
            ),
            if (onRetry != null) ...[
              VerticalSpacer.normal,
              RbyButton.text(
                label: const Text('retry'),
                onTap: onRetry,
              ),
            ],
            if (onChangeFilter != null) ...[
              VerticalSpacer.normal,
              RbyButton.text(
                label: const Text('change filter'),
                onTap: onChangeFilter,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
