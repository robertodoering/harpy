import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/__old_components/screens/login/login_screen.dart';
import 'package:harpy/__old_components/screens/settings/settings_screen.dart';
import 'package:harpy/__old_components/screens/user_profile/user_profile_screen.dart';
import 'package:harpy/__old_stores/home_store.dart';
import 'package:harpy/__old_stores/login_store.dart';
import 'package:harpy/__old_stores/tokens.dart';
import 'package:harpy/__old_stores/user_store.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/widgets/shared/misc.dart';

void _navigateToProfileScreen(BuildContext context, User user) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UserProfileScreen(user: user),
    ),
  );
}

class HomeDrawer extends StatefulWidget {
  @override
  HomeDrawerState createState() {
    return new HomeDrawerState();
  }
}

class HomeDrawerState extends State<HomeDrawer> with StoreWatcherMixin {
  UserStore store;

  @override
  void initState() {
    super.initState();
    store = listenToStore(Tokens.user);
  }

  @override
  void dispose() {
    super.dispose();
    unlistenFromStore(store);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserDrawerHeader(store.loggedInUser),
          _buildActions(context),
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: <Widget>[
        // profile
        ListTile(
          leading: Icon(Icons.face),
          title: Text("Profile"),
          onTap: () => _navigateToProfileScreen(context, store.loggedInUser),
        ),

        // clear cache (debug)
        ListTile(
          leading: Icon(Icons.close),
          title: Text("Clear cache"),
          onTap: HomeStore.clearCache,
        ),

        Divider(),

        // settings
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
          onTap: () => _navigateToSettingsScreen(context),
        )
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ListTile(
          leading: Icon(Icons.arrow_back),
          title: Text("Logout"),
          onTap: () => _logoutAndNavigateBack(context),
        ),
      ),
    );
  }

  void _navigateToSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }

  Future<void> _logoutAndNavigateBack(BuildContext context) async {
    await LoginStore.twitterLogout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

/// The [Drawer] header that contains information about the logged in [User].
class UserDrawerHeader extends StatelessWidget {
  final User user;

  const UserDrawerHeader(this.user);

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
          SizedBox(width: double.infinity),
          GestureDetector(
            onTap: () => _navigateToProfileScreen(context, user),
            child: CircleAvatar(
              radius: 32.0,
              backgroundColor: Colors.transparent,
              backgroundImage: CachedNetworkImageProvider(
                user.userProfileImageOriginal,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(user.name, style: Theme.of(context).textTheme.display2),
          Text("@${user.screenName}",
              style: Theme.of(context).textTheme.display1),
          SizedBox(height: 8.0),
          FollowersCount(
            followers: user.followersCount,
            following: user.friendsCount,
          ),
        ],
      ),
    );
  }
}
