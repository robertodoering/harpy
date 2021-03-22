import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class HarpyBackButton extends StatelessWidget {
  const HarpyBackButton();

  @override
  Widget build(BuildContext context) {
    return HarpyButton.flat(
      padding: const EdgeInsets.all(16),
      icon: Transform.translate(
        offset: const Offset(-1, 0),
        child: const Icon(CupertinoIcons.left_chevron),
      ),
      onTap: Navigator.of(context).pop,
    );
  }
}
