import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/misc/misc.dart';

class HomeTabCustomization extends StatelessWidget {
  const HomeTabCustomization();

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
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      // remove focus on background tap
      onTap: () => removeFocus(context),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: DefaultEdgeInsets.all(),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  _buildInfoText(theme),
                  defaultVerticalSpacer,
                  const HomeTabReorderList(),
                  const AddListHomeTabCard(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: mediaQuery.padding.bottom),
          ),
        ],
      ),
    );
  }
}
