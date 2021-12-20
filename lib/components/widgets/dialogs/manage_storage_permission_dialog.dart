import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// A simple dialog to inform the user that the 'storage management permissions'
/// are required.
class ManageStoragePermissionDialog extends StatelessWidget {
  const ManageStoragePermissionDialog({
    required this.path,
  });

  final String path;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HarpyDialog(
      title: const Text('storage permission'),
      content: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: 'harpy needs storage management permissions to access\n',
            ),
            TextSpan(
              text: path,
              style: TextStyle(color: theme.colorScheme.secondary),
            ),
          ],
        ),
      ),
      actions: const [
        DialogAction(result: false, text: 'cancel'),
        DialogAction(result: true, text: 'grant'),
      ],
    );
  }
}
