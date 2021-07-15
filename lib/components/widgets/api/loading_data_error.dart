import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds an error message with an optional retry button when [onRetry] is not
/// `null`.
class LoadingDataError extends StatelessWidget {
  const LoadingDataError({
    required this.message,
    this.onRetry,
    this.onClearFilter,
  });

  final Widget message;
  final VoidCallback? onRetry;
  final VoidCallback? onClearFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: DefaultEdgeInsets.all(),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle(
            style: theme.textTheme.headline6!,
            textAlign: TextAlign.center,
            child: message,
          ),
          if (onRetry != null) ...[
            defaultVerticalSpacer,
            HarpyButton.flat(
              dense: true,
              text: const Text('retry'),
              onTap: onRetry,
            ),
          ],
          if (onClearFilter != null) ...[
            defaultVerticalSpacer,
            HarpyButton.flat(
              dense: true,
              text: const Text('clear filter'),
              onTap: onClearFilter,
            ),
          ],
        ],
      ),
    );
  }
}
