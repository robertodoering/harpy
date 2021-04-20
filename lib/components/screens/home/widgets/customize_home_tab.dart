import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class CustomizeHomeTab extends StatelessWidget {
  const CustomizeHomeTab({
    this.cardColor,
  });

  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    final Widget child = HarpyTab(
      icon: const Icon(FeatherIcons.settings),
      text: const Text('customize'),
      cardColor: cardColor,
    );

    if (Harpy.isFree) {
      return Bubbled(
        bubble: const FlareIcon.shiningStar(size: 18),
        bubbleOffset: const Offset(4, -4),
        child: child,
      );
    } else {
      return child;
    }
  }
}
