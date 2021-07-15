import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class RetryAuthenticationDialog extends StatelessWidget {
  const RetryAuthenticationDialog();

  @override
  Widget build(BuildContext context) {
    return const HarpyDialog(
      title: Text('login'),
      content: Text(
        'unable to initialize authenticated user\n\n'
        'check your connection and try again',
      ),
      actions: [
        DialogAction(result: false, text: 'cancel'),
        DialogAction(result: true, text: 'retry'),
      ],
    );
  }
}
