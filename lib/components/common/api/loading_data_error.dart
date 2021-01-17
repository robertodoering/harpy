import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

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
      padding: DefaultEdgeInsets.all(),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            message,
            style: theme.textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          defaultVerticalSpacer,
          if (onTap != null)
            HarpyButton.flat(
              dense: true,
              text: const Text('retry'),
              onTap: onTap,
            ),
        ],
      ),
    );
  }
}
