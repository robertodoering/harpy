import 'package:flutter/material.dart';
import 'package:harpy/components/common/dialogs/harpy_dialog.dart';

/// Builds a [HarpyDialog] for a crash report.
///
/// Used by the [ErrorReporter].
class ErrorDialog extends StatelessWidget {
  const ErrorDialog();

  @override
  Widget build(BuildContext context) {
    return const HarpyDialog(
      title: Text('Crash report'),
      content: Text('An unexpected error occurred.\n'
          'Send a crash report?'),
      actions: <DialogAction<bool>>[
        DialogAction<bool>(
          result: false,
          text: 'No, thanks',
        ),
        DialogAction<bool>(
          result: true,
          text: 'Send report',
        ),
      ],
    );
  }
}
