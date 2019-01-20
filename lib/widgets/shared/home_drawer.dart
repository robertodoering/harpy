import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/core/utils/harpy_navigator.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/widgets/screens/login_screen.dart';
import 'package:harpy/widgets/screens/settings_screen.dart';
import 'package:harpy/widgets/shared/misc.dart';

/// The [Drawer] shown in the [HomeScreen].
///
/// It displays the logged in [User] on the top and allows to navigate to
/// different parts of the app and to logout.
class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginModel = LoginModel.of(context);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserDrawerHeader(loginModel.loggedInUser),
          Expanded(child: _buildActions(context)),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final loginModel = LoginModel.of(context);

    return Column(
      children: <Widget>[
        // profile
        ListTile(
          leading: Icon(Icons.face),
          title: Text("Profile"),
          onTap: () => HarpyNavigator.push(
              context, Text("user screen ${loginModel.loggedInUser}")), // todo
        ),

        // clear cache (debug)
        ListTile(
          leading: Icon(Icons.close),
          title: Text("Clear cache"),
          onTap: null, // todo
        ),

        Divider(),

        // settings
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
          onTap: () => HarpyNavigator.push(context, SettingsScreen()),
        ),

        Expanded(child: Container()),

        ListTile(
          leading: Icon(Icons.arrow_back),
          title: Text("Logout"),
          onTap: () => _logoutAndNavigateBack(context),
        ),
      ],
    );
  }

  Future<void> _logoutAndNavigateBack(BuildContext context) async {
    final loginModel = LoginModel.of(context);
    await loginModel.logout();

    HarpyNavigator.push(context, LoginScreen());
  }
}

/// The [UserDrawerHeader] that contains information about the logged in [User].
class UserDrawerHeader extends StatelessWidget {
  const UserDrawerHeader(this.user);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.fromLTRB(
        16.0,
        16.0 + MediaQuery.of(context).padding.top, // + statusbar height
        16.0,
        8.0,
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
          SizedBox(height: 16.0),
          FollowersCount(
            followers: user.followersCount, // todo: limit number
            following: user.friendsCount, // todo: limit number
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // tappable circle avatar
        GestureDetector(
          onTap: () =>
              HarpyNavigator.push(context, Text("user screen")), // todo
          child: CircleAvatar(
            radius: 32.0,
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(
              user.userProfileImageOriginal,
            ),
          ),
        ),

        SizedBox(width: 16.0),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: Theme.of(context).textTheme.display2,
              ),
              Text(
                "@${user.screenName}",
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
