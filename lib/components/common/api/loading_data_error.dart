import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

/// Builds an error message with an optional retry button when [onRetry] is not
/// `null`.
class LoadingDataError extends StatelessWidget {
  const LoadingDataError({
    @required this.message,
    this.onRetry,
    this.onClearFilter,
  });

  final Widget message;
  final VoidCallback onRetry;
  final VoidCallback onClearFilter;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: DefaultEdgeInsets.all(),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DefaultTextStyle(
            style: theme.textTheme.headline6,
            textAlign: TextAlign.center,
            child: message,
          ),
          if (onRetry != null) ...<Widget>[
            defaultVerticalSpacer,
            HarpyButton.flat(
              dense: true,
              text: const Text('retry'),
              onTap: onRetry,
            ),
          ],
          if (onClearFilter != null) ...<Widget>[
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
