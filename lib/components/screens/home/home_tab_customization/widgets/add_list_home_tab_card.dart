import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class AddListHomeTabCard extends StatelessWidget {
  const AddListHomeTabCard({
    this.proDisabled = false,
  });

  /// Whether the add new list card should appear disabled with a pro icon
  /// bubble.
  ///
  /// This indicates that only the pro version can add more lists.
  final bool proDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = context.watch<HomeTabModel>();

    final iconSize = theme.iconTheme.size!;

    final Widget icon = Padding(
      padding: EdgeInsets.all(HarpyTab.tabPadding(context)),
      child: proDisabled
          ? FlareIcon.shiningStar(size: iconSize)
          : Icon(CupertinoIcons.add, size: iconSize),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: kBorderRadius,
      ),
      child: InkWell(
        onTap: proDisabled
            ? () => launchUrl(
                  'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro',
                )
            : () => app<HarpyNavigator>().pushShowListsScreen(
                  onListSelected: (list) {
                    Navigator.of(context).maybePop();

                    model.addList(list: list);
                  },
                ),
        borderRadius: kBorderRadius,
        child: Row(
          children: [
            icon,
            Expanded(
              child: Text(
                proDisabled ? 'add more lists with harpy pro' : 'add list',
                style: theme.textTheme.subtitle1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
