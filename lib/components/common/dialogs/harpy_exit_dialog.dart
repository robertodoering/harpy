import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/dialogs/harpy_dialog.dart';

class HarpyExitDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      title: const Text('exit harpy'),
      content: const Text('do you really want to exit?'),
      actions: [
        HarpyButton.flat(
          text: const Text('no'),
          onTap: () => Navigator.of(context).pop<bool>(false),
        ),
        HarpyButton.flat(
          text: const Text('yes'),
          onTap: () => Navigator.of(context).pop<bool>(true),
        ),
      ],
    );
  }
}
