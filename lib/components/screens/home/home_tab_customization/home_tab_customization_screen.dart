import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
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
    required this.model,
  });

  final HomeTabModel model;

  static const route = 'home_tab_customization';

  @override
  _HomeTabCustomizationScreenState createState() =>
      _HomeTabCustomizationScreenState();
}

class _HomeTabCustomizationScreenState extends State<HomeTabCustomizationScreen>
    with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    harpyRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    harpyRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    if (isFree) {
      widget.model.initialize();
    }
  }

  Widget _buildProCard(ThemeData theme) {
    return const HarpyProCard(
      children: [
        Text(
          'unlock the full potential of customizing the home screen with '
          'harpy pro',
        ),
      ],
    );
  }

  Widget _buildInfoText(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(CupertinoIcons.info, color: theme.colorScheme.primary),
        horizontalSpacer,
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
      itemBuilder: (_) {
        return [
          const HarpyPopupMenuItem<int>(
            value: 0,
            text: Text('reset to default'),
          ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return ChangeNotifierProvider<HomeTabModel>.value(
      value: widget.model,
      child: HarpyScaffold(
        title: 'home customization',
        actions: [_buildAction()],
        body: GestureDetector(
          // remove focus on background tap
          onTap: FocusScope.of(context).unfocus,
          child: Builder(
            builder: (context) {
              final model = context.watch<HomeTabModel>();

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: config.edgeInsets,
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (isFree) ...[
                          _buildProCard(theme),
                          verticalSpacer,
                          _buildInfoText(theme),
                          verticalSpacer,
                        ],
                        const HomeTabReorderList(),
                        if (model.canAddMoreLists)
                          const AddListHomeTabCard()
                        else if (isFree)
                          const AddListHomeTabCard(proDisabled: true)
                      ]),
                    ),
                  ),
                  const SliverBottomPadding(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
