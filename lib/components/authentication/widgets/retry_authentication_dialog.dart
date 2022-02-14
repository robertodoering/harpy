import 'package:flutter/material.dart';

class RetryAuthenticationDialog extends StatelessWidget {
  const RetryAuthenticationDialog();

  @override
  Widget build(BuildContext context) {
    // TODO: harpy dialog
    return AlertDialog(
      title: const Text('login'),
      content: const Text(
        'unable to initialize authenticated user\n\n'
        'check your connection and try again',
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('retry'),
        ),
      ],
    );
  }
}
