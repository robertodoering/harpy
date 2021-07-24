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
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final authCubit = context.watch<AuthenticationCubit>();

    return Column(
      children: [
        Expanded(
          child: ListView(
            primary: false,
            padding: EdgeInsets.zero,
            children: [
              // profile
              HarpyListTile(
                leading: const Icon(CupertinoIcons.person),
                title: const Text('profile'),
                onTap: () async {
                  await app<HarpyNavigator>().maybePop();
                  app<HarpyNavigator>().pushUserProfile(
                    screenName: authCubit.state.user!.handle,
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
                  leading: FlareIcon.shiningStar(
                    size: theme.iconTheme.size! + 8,
                  ),
                  leadingPadding: config.edgeInsets.copyWith(
                    left: max(config.paddingValue - 4, 0),
                    right: max(config.paddingValue - 4, 0),
                    top: max(config.paddingValue - 4, 0),
                    bottom: max(config.paddingValue - 4, 0),
                  ),
                  title: const Text('harpy pro'),
                  onTap: () => app<MessageService>().show('coming soon!'),
                ),

              // about
              HarpyListTile(
                leading: FlareIcon.harpyLogo(
                  size: theme.iconTheme.size!,
                ),
                leadingPadding: config.edgeInsets.copyWith(
                  left: max(config.paddingValue - 6, 0),
                  right: max(config.paddingValue - 6, 0),
                  top: max(config.paddingValue - 6, 0),
                  bottom: max(config.paddingValue - 6, 0),
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
          onTap: authCubit.logout,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: HarpyBackground(
        child: Column(
          children: [
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
