import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/about/widgets/about_screen.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_event.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/components/common/misc/harpy_background.dart';
import 'package:harpy/components/settings/common/widgets/settings_screen.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_drawer_header.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/misc/harpy_navigator.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer();

  Widget _buildActions(BuildContext context) {
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
                leading: const Icon(Icons.face),
                title: const Text('Profile'),
                onTap: () async {
                  await app<HarpyNavigator>().state.maybePop();
                  app<HarpyNavigator>().pushUserProfile(
                    screenName: authBloc.authenticatedUser.screenName,
                  );
                },
              ),

              const Divider(),

              // settings
              ListTile(
                leading: const Icon(Icons.settings),
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
                    offset: Offset(-2.5, 0),
                  ),
                  title: const Text('Harpy Pro'),
                  // todo: add harpy pro analytics
                  onTap: () => app<MessageService>().show('Coming soon!'),
                ),

              // about
              ListTile(
                leading: const FlareIcon.harpyLogo(),
                title: const Text('About'),
                onTap: () async {
                  await app<HarpyNavigator>().state.maybePop();
                  app<HarpyNavigator>().pushNamed(AboutScreen.route);
                },
              ),
            ],
          ),
        ),
        // logout
        ListTile(
          leading: const Icon(Icons.exit_to_app),
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
