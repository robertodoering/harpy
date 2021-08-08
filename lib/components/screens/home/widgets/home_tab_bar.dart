import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
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
        for (HomeTabEntry entry in model.visibleEntries)
          _mapEntryTabs(entry, cardColor),
      ],
      endWidgets: const [
        CustomizeHomeTab(),
      ],
    );
  }
}
