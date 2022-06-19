import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

/// Builds an error message that fades into view. with optional actions.
class LoadingError extends ConsumerWidget {
  const LoadingError({
    required this.message,
    this.onRetry,
    this.onChangeFilter,
  });

  final Widget message;
  final VoidCallback? onRetry;
  final VoidCallback? onChangeFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return ImmediateOpacityAnimation(
      duration: kShortAnimationDuration,
      child: Container(
        padding: display.edgeInsets,
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextStyle(
              style: theme.textTheme.headline6!,
              textAlign: TextAlign.center,
              child: message,
            ),
            if (onRetry != null) ...[
              verticalSpacer,
              HarpyButton.text(
                label: const Text('retry'),
                onTap: onRetry,
              ),
            ],
            if (onChangeFilter != null) ...[
              verticalSpacer,
              HarpyButton.text(
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
