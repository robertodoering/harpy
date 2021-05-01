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
    final ThemeData theme = Theme.of(context);
    final AuthenticationBloc authBloc = AuthenticationBloc.of(context);

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            primary: false,
            padding: EdgeInsets.zero,
            children: <Widget>[
              // profile
              ListTile(
                leading: const Icon(CupertinoIcons.person),
                title: const Text('Profile'),
                onTap: () async {
                  await app<HarpyNavigator>().state.maybePop();
                  app<HarpyNavigator>().pushUserProfile(
                    screenName: authBloc.authenticatedUser.screenName,
                  );
                },
              ),

              // compose tweet
              ListTile(
                leading: const Icon(FeatherIcons.feather),
                title: const Text('Compose tweet'),
                onTap: () async {
                  await app<HarpyNavigator>().state.maybePop();
                  app<HarpyNavigator>().pushComposeScreen();
                },
              ),

              // lists
              ListTile(
                leading: const Icon(CupertinoIcons.list_bullet),
                title: const Text('Lists'),
                onTap: () async {
                  await app<HarpyNavigator>().state.maybePop();
                  app<HarpyNavigator>().pushShowListsScreen();
                },
              ),

              const Divider(),

              // settings
              ListTile(
                leading: const Icon(FeatherIcons.settings),
                title: const Text('Settings'),
                onTap: () async {
                  await app<HarpyNavigator>().state.maybePop();
                  app<HarpyNavigator>().pushNamed(SettingsScreen.route);
                },
              ),

              // harpy pro
              if (Harpy.isFree)
                ListTile(
                  leading: const FlareIcon.shiningStar(
                    size: 30,
                    offset: Offset(-4, 0),
                  ),
                  title: const Text('Harpy pro'),
                  // todo: add harpy pro analytics
                  onTap: () => app<MessageService>().show('coming soon!'),
                ),

              // about
              ListTile(
                leading: const FlareIcon.harpyLogo(offset: Offset(-4, 0)),
                title: const Text('About'),
                onTap: () async {
                  await app<HarpyNavigator>().state.maybePop();
                  app<HarpyNavigator>().pushNamed(AboutScreen.route);
                },
              ),

              // beta info
              ListTile(
                leading: Icon(CupertinoIcons.info, color: theme.accentColor),
                title: Text(
                  'Beta info',
                  style: TextStyle(
                    color: theme.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  await app<HarpyNavigator>().state.maybePop();
                  app<HarpyNavigator>().pushNamed(BetaInfoScreen.route);
                },
              ),
            ],
          ),
        ),

        // logout
        ListTile(
          leading: const Icon(CupertinoIcons.square_arrow_left),
          title: const Text('Logout'),
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
