import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/about/widgets/about_screen.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_event.dart';
import 'package:harpy/components/beta_info/widgets/beta_info_screen.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/components/common/misc/harpy_background.dart';
import 'package:harpy/components/compose/widget/compose_screen.dart';
import 'package:harpy/components/search/tweet/widgets/tweet_search_screen.dart';
import 'package:harpy/components/search/user/widgets/user_search_screen.dart';
import 'package:harpy/components/settings/common/widgets/settings_screen.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_drawer_header.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
                leading: const Icon(Icons.face),
                title: const Text('profile'),
                onTap: () async {
                  await app<HarpyNavigator>().state.maybePop();
                  app<HarpyNavigator>().pushUserProfile(
                    screenName: authBloc.authenticatedUser.screenName,
                  );
                },
              ),

              // compose tweet
              ListTile(
                leading: const Icon(LineAwesomeIcons.alternate_feather),
                title: const Text('compose Tweet'),
                onTap: () async {
                  await app<HarpyNavigator>().state.maybePop();
                  app<HarpyNavigator>().pushNamed(ComposeScreen.route);
                },
              ),

              // search
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('search users'),
                onTap: () async {
                  await app<HarpyNavigator>().state.maybePop();
                  app<HarpyNavigator>().pushNamed(UserSearchScreen.route);
                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('search tweets'),
                onTap: () async {
                  await app<HarpyNavigator>().state.maybePop();
                  app<HarpyNavigator>().pushNamed(TweetSearchScreen.route);
                },
              ),

              const Divider(),

              // settings
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('settings'),
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
                  title: const Text('harpy pro'),
                  // todo: add harpy pro analytics
                  onTap: () => app<MessageService>().show('coming soon!'),
                ),

              // about
              ListTile(
                leading: const FlareIcon.harpyLogo(),
                title: const Text('about'),
                onTap: () async {
                  await app<HarpyNavigator>().state.maybePop();
                  app<HarpyNavigator>().pushNamed(AboutScreen.route);
                },
              ),

              // beta info
              ListTile(
                leading: Icon(Icons.info_outline, color: theme.accentColor),
                title: Text(
                  'beta info',
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
          leading: const Icon(Icons.exit_to_app),
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
