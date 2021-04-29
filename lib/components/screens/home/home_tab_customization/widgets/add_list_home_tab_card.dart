import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/harpy_navigator.dart';
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
    final ThemeData theme = Theme.of(context);
    final HomeTabModel model = context.watch<HomeTabModel>();

    final Widget icon = Padding(
      padding: const EdgeInsets.all(HarpyTab.tabPadding),
      child: proDisabled
          ? const FlareIcon.shiningStar(size: HarpyTab.tabIconSize)
          : const Icon(
              CupertinoIcons.add,
              size: HarpyTab.tabIconSize,
            ),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: kDefaultBorderRadius,
      ),
      child: InkWell(
        onTap: proDisabled
            ? null
            : () => app<HarpyNavigator>().pushShowListsScreen(
                  onListSelected: (TwitterListData list) {
                    Navigator.of(context).maybePop();

                    model.addList(list: list);
                  },
                ),
        borderRadius: kDefaultBorderRadius,
        child: Row(
          children: <Widget>[
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
