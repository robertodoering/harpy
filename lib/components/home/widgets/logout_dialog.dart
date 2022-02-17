import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog();

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      title: const Text('really logout?'),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('logout'),
        ),
      ],
    );
  }
}
