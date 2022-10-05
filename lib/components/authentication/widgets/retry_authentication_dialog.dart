import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class RetryAuthenticationDialog extends StatelessWidget {
  const RetryAuthenticationDialog();

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      title: const Text('login'),
      content: const Text(
        'unable to initialize user\n\n'
        'please check your connection and try again',
      ),
      actions: [
        HarpyButton.text(
          label: const Text('logout'),
          onTap: Navigator.of(context).pop,
        ),
        HarpyButton.elevated(
          label: const Text('retry'),
          onTap: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
