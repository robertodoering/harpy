import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class CustomizeHomeTab extends StatelessWidget {
  const CustomizeHomeTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Widget child = HarpyButton.raised(
      elevation: 0,
      backgroundColor: theme.colorScheme.secondary.withOpacity(.9),
      padding: EdgeInsets.all(HarpyTab.tabPadding(context)),
      icon: const Icon(FeatherIcons.settings),
      onTap: () => app<HarpyNavigator>().pushHomeTabCustomizationScreen(
        model: context.read<HomeTabModel>(),
      ),
    );

    if (Harpy.isFree) {
      return Bubbled(
        bubble: const FlareIcon.shiningStar(),
        bubbleOffset: const Offset(4, -4),
        child: child,
      );
    } else {
      return child;
    }
  }
}
