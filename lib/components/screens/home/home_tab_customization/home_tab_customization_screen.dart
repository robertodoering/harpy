import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

/// A screen that allows the user to customize the home screen content.
///
/// Lists can be added as tabs to the home screen and the default tabs can
/// customized.
///
/// Customization includes changing the icon and name for a tab and changing
/// the order in which they appear (and thus allowing to change what view is
/// the initial view in the home screen).
///
/// Customization is limited in the free version by only allowing the user to
/// add and customize one list.
/// Any other customization changes will be discarded when the use leaves
/// this screen.
class HomeTabCustomizationScreen extends StatefulWidget {
  const HomeTabCustomizationScreen({
    @required this.model,
  });

  final HomeTabModel model;

  static const String route = 'home_tab_customization_screen';

  @override
  _HomeTabCustomizationScreenState createState() =>
      _HomeTabCustomizationScreenState();
}

class _HomeTabCustomizationScreenState extends State<HomeTabCustomizationScreen>
    with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    app<HarpyNavigator>().routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.dispose();
    app<HarpyNavigator>().routeObserver.unsubscribe(this);
  }

  @override
  void didPop() {
    if (Harpy.isFree) {
      widget.model.initialize();
    }
  }

  Widget _buildProCard(ThemeData theme) {
    return HarpyProCard(
      children: <Widget>[
        const Text(
          'unlock the full potential of customizing the home screen with '
          'harpy pro',
        ),
        Text(
          '(coming soon)',
          style: theme.textTheme.subtitle2.copyWith(
            color: Colors.white.withOpacity(.6),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(CupertinoIcons.info, color: theme.accentColor),
        defaultHorizontalSpacer,
        const Flexible(
          child: Text(
            'changes other than adding lists are not saved in the free version'
            ' of harpy',
          ),
        ),
      ],
    );
  }

  Widget _buildAction() {
    return CustomPopupMenuButton<void>(
      icon: const Icon(CupertinoIcons.ellipsis_vertical),
      onSelected: (_) {
        HapticFeedback.lightImpact();
        widget.model.setToDefault();
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<void>>[
          const HarpyPopupMenuItem<void>(
            value: 0,
            text: Text('reset to default'),
          ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final ThemeData theme = Theme.of(context);

    return ChangeNotifierProvider<HomeTabModel>.value(
      value: widget.model,
      child: HarpyScaffold(
        title: 'home customization',
        actions: <Widget>[_buildAction()],
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
                          if (Harpy.isFree) ...<Widget>[
                            _buildProCard(theme),
                            defaultVerticalSpacer,
                            _buildInfoText(theme),
                            defaultVerticalSpacer,
                          ],
                          const HomeTabReorderList(),
                          if (model.canAddMoreLists)
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
