import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog();

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      title: const Text('really logout?'),
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
