import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class AddHomeTab extends StatelessWidget {
  const AddHomeTab();

  @override
  Widget build(BuildContext context) {
    final Widget child = InkWell(
      borderRadius: kDefaultBorderRadius,
      onTap: () async {
        final bool result = await showDialog<bool>(
          context: context,
          builder: (_) => const ProDialog(
            feature: 'tab customization',
          ),
        );
      },
      child: Card(
        child: Container(
          padding: DefaultEdgeInsets.all(),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
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
