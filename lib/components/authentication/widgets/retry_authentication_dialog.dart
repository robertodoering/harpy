import 'package:flutter/material.dart';
import 'package:rby/rby.dart';

class RetryAuthenticationDialog extends StatelessWidget {
  const RetryAuthenticationDialog();

  @override
  Widget build(BuildContext context) {
    return RbyDialog(
      title: const Text('login'),
      content: const Text(
        'unable to initialize user\n\n'
        'please check your connection and try again',
      ),
      actions: [
        RbyButton.text(
          label: const Text('logout'),
          onTap: Navigator.of(context).pop,
        ),
        RbyButton.elevated(
          label: const Text('retry'),
          onTap: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
