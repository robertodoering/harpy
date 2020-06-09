import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/screens/about_screen.dart';
import 'package:harpy/components/screens/compose_tweet_screen.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/components/screens/login_screen.dart';
import 'package:harpy/components/screens/settings_screen.dart';
import 'package:harpy/components/widgets/shared/flare_icons.dart';
import 'package:harpy/components/widgets/shared/harpy_background.dart';
import 'package:harpy/components/widgets/shared/misc.dart';
import 'package:harpy/core/misc/flushbar_service.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/models/settings/media_settings_model.dart';

/// The [Drawer] shown in the [HomeScreen].
///
/// It displays the logged in [User] on the top and allows to navigate to
/// different parts of the app and logout.
class HomeDrawer extends StatelessWidget {
  Future<void> _logoutAndNavigateBack(BuildContext context) async {
    final loginModel = LoginModel.of(context);
    await loginModel.logout();

    HarpyNavigator.pushReplacementNamed(LoginScreen.route);
  }

  Widget _buildActions(BuildContext context, LoginModel loginModel) {
    return Column(
      children: <Widget>[
        // profile
        ListTile(
          leading: const Icon(Icons.face),
          title: const Text("Profile"),
          onTap: () async {
            await Navigator.of(context).maybePop();
            HarpyNavigator.pushUserProfileScreen(
              user: loginModel.loggedInUser,
            );
          },
        ),

        // compose tweet
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text("Compose a new Tweet"),
          onTap: () async {
            await Navigator.of(context).maybePop();
            HarpyNavigator.push(
              const ComposeTweetScreen(),
              name: "compose_tweet",
            );
          },
        ),

        const Divider(),

        // settings
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Settings"),
          onTap: () async {
            await Navigator.of(context).maybePop();
            HarpyNavigator.push(const SettingsScreen(), name: "settings");
          },
        ),

        // harpy pro
        if (Harpy.isFree)
          ListTile(
            leading: const FlareIcon.shiningStar(
              size: 30,
              offset: Offset(-2.5, 0),
            ),
            title: const Text("Harpy Pro"),
            onTap: () {
              // todo: link to harpy pro
              app<FlushbarService>().info("Not yet available");
            },
          ),

        // about
        ListTile(
          leading: const FlareIcon.harpyLogo(),
          title: const Text("About"),
          onTap: () async {
            await Navigator.of(context).maybePop();
            HarpyNavigator.push(const AboutScreen(), name: "about");
          },
        ),

        const Spacer(),

        ListTile(
          leading: const Icon(Icons.arrow_back),
          title: const Text("Logout"),
          onTap: () => _logoutAndNavigateBack(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginModel = LoginModel.of(context);

    return Drawer(
      child: HarpyBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UserDrawerHeader(loginModel.loggedInUser),
            Expanded(child: _buildActions(context, loginModel)),
          ],
        ),
      ),
    );
  }
}

/// The [UserDrawerHeader] that contains information about the logged in [User].
class UserDrawerHeader extends StatelessWidget {
  const UserDrawerHeader(this.user);

  final User user;

  Future<void> _navigateToUserScreen(BuildContext context) async {
    await Navigator.of(context).maybePop();
    HarpyNavigator.pushUserProfileScreen(user: user);
  }

  Widget _buildAvatarRow(BuildContext context) {
    final mediaSettingsModel = MediaSettingsModel.of(context);

    final String imageUrl = user.getProfileImageUrlFromQuality(
      mediaSettingsModel.quality,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // circle avatar
        GestureDetector(
          onTap: () => _navigateToUserScreen(context),
          child: CachedCircleAvatar(
            radius: 32,
            imageUrl: imageUrl,
          ),
        ),

        const SizedBox(width: 16),

        // name + username
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => _navigateToUserScreen(context),
                child: Text(
                  user.name,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => _navigateToUserScreen(context),
                child: Text(
                  "@${user.screenName}",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.fromLTRB(
        16,
        16 + MediaQuery.of(context).padding.top, // + statusbar height
        16,
        8,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAvatarRow(context),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FollowersCount(user),
          ),
        ],
      ),
    );
  }
}
