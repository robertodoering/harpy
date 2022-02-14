import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('really logout?'),
      actionsAlignment: MainAxisAlignment.spaceAround,
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
