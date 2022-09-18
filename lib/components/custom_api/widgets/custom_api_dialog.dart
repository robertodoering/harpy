import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class CustomApiDialog extends StatelessWidget {
  const CustomApiDialog();

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      title: const Text('logout to enter a custom api key?'),
      content: const Text(
        'if you have access to your own Twitter api key, '
        'you can use it in harpy to reduce app-wide rate limitations.',
      ),
      actions: [
        HarpyButton.text(
          label: const Text('cancel'),
          onTap: Navigator.of(context).pop,
        ),
        HarpyButton.elevated(
          label: const Text('logout'),
          onTap: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
