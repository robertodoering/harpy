import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class HarpyLogoutDialog extends StatelessWidget {
  const HarpyLogoutDialog();

  @override
  Widget build(BuildContext context) {
    return const HarpyDialog(
      title: Text('really logout?'),
      actions: [
        DialogAction<bool>(
          text: 'cancel',
          result: false,
        ),
        DialogAction<bool>(
          text: 'logout',
          result: true,
        ),
      ],
    );
  }
}
