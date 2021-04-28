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
  const CustomizeHomeTab({
    this.cardColor,
  });

  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Widget child = HarpyButton.flat(
      padding: const EdgeInsets.all(HarpyTab.tabPadding - 2),
      icon: const Icon(FeatherIcons.settings),
      iconSize: HarpyTab.tabIconSize + 2,
      foregroundColor: theme.iconTheme.color.withOpacity(.8),
      onTap: () => app<HarpyNavigator>().pushHomeTabCustomizationScreen(
        model: context.read<HomeTabModel>(),
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
