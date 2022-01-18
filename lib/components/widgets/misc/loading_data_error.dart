import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Builds an error message with an optional retry button when [onRetry] is not
/// `null`.
class LoadingDataError extends StatelessWidget {
  const LoadingDataError({
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
    final config = context.watch<ConfigCubit>().state;

    return Container(
      padding: config.edgeInsets,
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
            verticalSpacer,
            HarpyButton.flat(
              dense: true,
              text: const Text('retry'),
              onTap: onRetry,
            ),
          ],
          if (onChangeFilter != null) ...[
            verticalSpacer,
            HarpyButton.flat(
              dense: true,
              text: Text(
                'change filter',
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: onChangeFilter,
            ),
          ],
        ],
      ),
    );
  }
}
