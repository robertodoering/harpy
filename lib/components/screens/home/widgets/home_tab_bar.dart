import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Builds the tab bar with the tabs for the home screen.
class HomeTabBar extends StatelessWidget with PreferredSizeWidget {
  const HomeTabBar();

  static const double height = HarpyTab.height + 8;

  @override
  Size get preferredSize => const Size(double.infinity, height);

  Widget _mapEntryTabs(HomeTabEntry entry, Color cardColor) {
    if (entry.isDefaultType && entry.id == 'mentions') {
      return MentionsTab(
        entry: entry,
        cardColor: cardColor,
      );
    } else {
      return HarpyTab(
        icon: HomeTabEntryIcon(entry.icon),
        text: entry.hasName ? Text(entry.name) : null,
        cardColor: cardColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final HomeTabModel model = context.watch<HomeTabModel>();

    final Color cardColor =
        Color.lerp(theme.cardTheme.color, theme.scaffoldBackgroundColor, .9)
            .withOpacity(.8);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      child: HarpyTabBar(
        tabs: <Widget>[
          for (HomeTabEntry entry in model.visibleEntries)
            _mapEntryTabs(entry, cardColor),
        ],
        endWidgets: <Widget>[
          CustomizeHomeTab(cardColor: cardColor),
        ],
      ),
    );
  }
}
