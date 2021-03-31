import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds the tab bar with the tabs for the home screen.
class HomeTabBar extends StatelessWidget with PreferredSizeWidget {
  const HomeTabBar();

  @override
  Size get preferredSize => const Size(double.infinity, HarpyTab.height);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color cardColor = theme.cardColor.withOpacity(.9);

    return SizedBox(
      width: double.infinity,
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
        endWidgets: <Widget>[
          AddHomeTab(cardColor: cardColor),
        ],
      ),
    );
  }
}
