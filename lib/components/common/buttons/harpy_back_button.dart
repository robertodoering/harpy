import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';

class HarpyBackButton extends StatelessWidget {
  const HarpyBackButton();

  @override
  Widget build(BuildContext context) {
    return HarpyButton.flat(
      padding: const EdgeInsets.all(16),
      icon: const Icon(CupertinoIcons.left_chevron),
      onTap: Navigator.of(context).pop,
    );
  }
}
