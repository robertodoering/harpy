import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:provider/provider.dart';

// todo: hide this when: is harpy pro and already added 5 lists

class AddListHarpyTabCard extends StatelessWidget {
  const AddListHarpyTabCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final HomeTabModel model = context.watch<HomeTabModel>();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: kDefaultBorderRadius,
      ),
      child: InkWell(
        onTap: () => app<HarpyNavigator>().pushShowListsScreen(
          onListSelected: (TwitterListData list) {
            Navigator.of(context).maybePop();

            // todo: select icon for new entry (maybe a random one by default)
            model.addList(list: list, icon: '');
          },
        ),
        borderRadius: kDefaultBorderRadius,
        child: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(HarpyTab.tabPadding),
              child: Icon(
                CupertinoIcons.add,
                size: HarpyTab.tabIconSize,
              ),
            ),
            Expanded(
              child: Text(
                'add list',
                style: theme.textTheme.subtitle1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
