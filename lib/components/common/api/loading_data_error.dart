import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';

/// Builds an error message with an optional retry button when [onTap] is not
/// `null`.
class LoadingDataError extends StatelessWidget {
  const LoadingDataError({
    @required this.message,
    this.onTap,
  });

  final String message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            message,
            style: theme.textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (onTap != null)
            HarpyButton.flat(
              dense: true,
              text: 'retry',
              onTap: onTap,
            ),
        ],
      ),
    );
  }
}
