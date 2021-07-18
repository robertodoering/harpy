import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer();

  Widget _buildActions(BuildContext context) {
    final config = context.watch<ConfigBloc>().state;
    final authBloc = AuthenticationBloc.of(context);

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            primary: false,
            padding: EdgeInsets.zero,
            children: <Widget>[
              // profile
              HarpyListTile(
                leading: const Icon(CupertinoIcons.person),
                title: const Text('profile'),
                onTap: () async {
                  await app<HarpyNavigator>().maybePop();
                  app<HarpyNavigator>().pushUserProfile(
                    screenName: authBloc.authenticatedUser!.handle,
                  );
                },
              ),

              // lists
              HarpyListTile(
                leading: const Icon(CupertinoIcons.list_bullet),
                title: const Text('lists'),
                onTap: () async {
                  await app<HarpyNavigator>().maybePop();
                  app<HarpyNavigator>().pushShowListsScreen();
                },
              ),

              const Divider(),

              // settings
              HarpyListTile(
                leading: const Icon(FeatherIcons.settings),
                title: const Text('settings'),
                onTap: () async {
                  await app<HarpyNavigator>().maybePop();
                  app<HarpyNavigator>().pushNamed(SettingsScreen.route);
                },
              ),

              // harpy pro
              if (Harpy.isFree)
                HarpyListTile(
                  leading: const FlareIcon.shiningStar(
                    size: 30,
                    offset: Offset(-4, 0),
                  ),
                  title: const Text('harpy pro'),
                  // todo: add harpy pro analytics
                  onTap: () => app<MessageService>().show('coming soon!'),
                ),

              // about
              HarpyListTile(
                leading: const FlareIcon.harpyLogo(),
                leadingPadding: config.edgeInsets.copyWith(
                  left: max(config.paddingValue - 6, 0),
                  right: max(config.paddingValue - 6, 0),
                ),
                title: const Text('about'),
                onTap: () async {
                  await app<HarpyNavigator>().maybePop();
                  app<HarpyNavigator>().pushNamed(AboutScreen.route);
                },
              ),
            ],
          ),
        ),

        // logout
        HarpyListTile(
          leading: const Icon(CupertinoIcons.square_arrow_left),
          title: const Text('logout'),
          onTap: () =>
              context.read<AuthenticationBloc>().add(const LogoutEvent()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: HarpyBackground(
        child: Column(
          children: <Widget>[
            const HomeDrawerHeader(),
            Expanded(
              child: SafeArea(
                top: false,
                child: _buildActions(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
