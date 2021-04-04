import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds the tab bar with the tabs for the home screen.
class HomeTabBar extends StatelessWidget with PreferredSizeWidget {
  const HomeTabBar();

  @override
  Size get preferredSize => const Size(double.infinity, HarpyTab.height + 8);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color cardColor =
        Color.lerp(theme.cardTheme.color, theme.scaffoldBackgroundColor, .9)
            .withOpacity(.8);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      child: HarpyTabBar(
        tabs: <Widget>[
          HarpyTab(
            icon: const Icon(CupertinoIcons.home),
            cardColor: cardColor,
          ),
          HarpyTab(
            icon: const Icon(CupertinoIcons.photo),
            cardColor: cardColor,
          ),
          MentionsTab(cardColor: cardColor),
          HarpyTab(
            icon: const Icon(CupertinoIcons.search),
            cardColor: cardColor,
          ),
        ],
        // todo: re-add when adding tab customization
        // endWidgets: <Widget>[
        //   AddHomeTab(cardColor: cardColor),
        // ],
      ),
    );
  }
}
