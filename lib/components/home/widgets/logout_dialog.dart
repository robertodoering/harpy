import 'package:flutter/material.dart';
import 'package:rby/rby.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog();

  @override
  Widget build(BuildContext context) {
    return RbyDialog(
      title: const Text('really logout?'),
      actions: [
        RbyButton.text(
          label: const Text('cancel'),
          onTap: Navigator.of(context).pop,
        ),
        RbyButton.elevated(
          label: const Text('logout'),
          onTap: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
