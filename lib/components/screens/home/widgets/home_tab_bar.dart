import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

/// Builds the tab bar with the tabs for the home screen.
class HomeTabBar extends StatelessWidget {
  const HomeTabBar({
    required this.padding,
  });

  final EdgeInsets padding;

  Widget _mapEntryTabs(HomeTabEntry entry, Color cardColor) {
    if (entry.isDefaultType && entry.id == 'mentions') {
      return MentionsTab(
        entry: entry,
      );
    } else {
      return HarpyTab(
        icon: HomeTabEntryIcon(entry.icon),
        text: entry.hasName ? Text(entry.name!) : null,
        cardColor: cardColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final harpyTheme = context.watch<HarpyTheme>();
    final model = context.watch<HomeTabModel>();

    final cardColor = harpyTheme.alternateCardColor;

    return HarpyTabBar(
      padding: padding,
      tabs: [
        const _DrawerTab(),
        for (HomeTabEntry entry in model.visibleEntries)
          _mapEntryTabs(entry, cardColor),
      ],
      endWidgets: const [
        _CustomizeHomeTab(),
      ],
    );
  }
}

class _DrawerTab extends StatelessWidget {
  const _DrawerTab();

  @override
  Widget build(BuildContext context) {
    final harpyTheme = context.watch<HarpyTheme>();

    return HarpyTab(
      cardColor: harpyTheme.alternateCardColor,
      selectedCardColor: harpyTheme.primaryColor,
      selectedForegroundColor: harpyTheme.onPrimary,
      icon: const RotatedBox(
        quarterTurns: 1,
        child: Icon(FeatherIcons.barChart2),
      ),
    );
  }
}

class _CustomizeHomeTab extends StatelessWidget {
  const _CustomizeHomeTab();

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
        bubbleOffset: const Offset(2, -2),
        child: child,
      );
    } else {
      return child;
    }
  }
}
