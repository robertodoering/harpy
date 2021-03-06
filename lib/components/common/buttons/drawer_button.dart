import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';

class DrawerButton extends StatelessWidget {
  const DrawerButton();

  @override
  Widget build(BuildContext context) {
    return HarpyButton.flat(
      padding: const EdgeInsets.all(16),
      icon: const RotatedBox(
        quarterTurns: 1,
        child: Icon(FeatherIcons.barChart2),
      ),
      onTap: Scaffold.of(context).openDrawer,
    );
  }
}
