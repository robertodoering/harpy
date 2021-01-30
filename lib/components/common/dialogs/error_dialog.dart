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
      title: Text('crash report'),
      content: Text('an unexpected error occurred.\n'
          'send a crash report?'),
      actions: <DialogAction<bool>>[
        DialogAction<bool>(
          result: false,
          text: 'no, thanks',
        ),
        DialogAction<bool>(
          result: true,
          text: 'send report',
        ),
      ],
    );
  }
}
