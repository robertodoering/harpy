import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class HomeTabCustomizationScreen extends StatelessWidget {
  const HomeTabCustomizationScreen({
    @required this.model,
  });

  final HomeTabModel model;

  static const String route = 'home_tab_customization_screen';

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

    return ChangeNotifierProvider<HomeTabModel>.value(
      value: model,
      child: HarpyScaffold(
        title: 'home customization',
        body: GestureDetector(
          // remove focus on background tap
          onTap: () => removeFocus(context),
          child: Builder(
            builder: (BuildContext context) {
              final HomeTabModel model = context.watch<HomeTabModel>();

              return CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: DefaultEdgeInsets.all(),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          _buildInfoText(theme),
                          defaultVerticalSpacer,
                          const HomeTabReorderList(),
                          if (model.value.canAddMoreLists)
                            const AddListHomeTabCard()
                          else if (Harpy.isFree)
                            const AddListHomeTabCard(proDisabled: true)
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: mediaQuery.padding.bottom),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
