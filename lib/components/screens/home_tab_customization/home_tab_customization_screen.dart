import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/misc/misc.dart';

class HomeTabCustomizationScreen extends StatelessWidget {
  const HomeTabCustomizationScreen();

  static const String route = 'home_tab_customization_screen';

  List<Widget> get _icons => const <Widget>[
        Icon(CupertinoIcons.home),
        Icon(CupertinoIcons.photo),
        Text('@'),
        Icon(CupertinoIcons.search),
      ];

  Widget _buildInfoText(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(CupertinoIcons.info, color: theme.accentColor),
        defaultSmallHorizontalSpacer,
        const Text(
          'changes are not saved',
          style: TextStyle(height: 1),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      // remove focus on background tap
      onTap: () => removeFocus(context),
      child: HarpyScaffold(
        title: 'tab customization',
        body: ListView(
          padding: DefaultEdgeInsets.all(),
          children: <Widget>[
            _buildInfoText(theme),
            defaultVerticalSpacer,
            ReorderableList(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (_, int index) => CustomizationRow(
                key: Key('$index'),
                index: index,
                icon: _icons[index],
              ),
              itemCount: 4,
              onReorder: (int oldIndex, int newIndex) {},
            ),
            const AddListRow(),
          ],
        ),
      ),
    );
  }
}
