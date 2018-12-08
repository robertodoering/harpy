import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/screens/main/main_screen.dart';
import 'package:harpy/components/screens/user_profile/user_profile_screen.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:harpy/stores/home_store.dart';
import 'package:harpy/stores/login_store.dart';
import 'package:harpy/stores/tokens.dart';
import 'package:harpy/stores/user_store.dart';

void _navigateToProfileScreen(BuildContext context, User user) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UserProfileScreen(user),
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
        ListTile(
          leading: Icon(Icons.face),
          title: Text("Profile"),
          onTap: () => _navigateToProfileScreen(context, store.loggedInUser),
        ),
        ListTile(
          leading: Icon(Icons.bookmark_border),
          title: Text("Bookmarks"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.close),
          title: Text("Clear cache"),
          onTap: HomeStore.clearCache,
        ),
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
          onTap: () => logoutAndNavigateBack(context),
        ),
      ),
    );
  }

  Future<void> logoutAndNavigateBack(BuildContext context) async {
    await LoginStore.twitterLogout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
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
          _buildFollowersCount(context),
        ],
      ),
    );
  }

  Widget _buildFollowersCount(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(formatNumber(user.friendsCount)),
        Text(" Following", style: Theme.of(context).textTheme.display1),
        SizedBox(width: 16),
        Text(formatNumber(user.followersCount)),
        Text(" Followers", style: Theme.of(context).textTheme.display1),
      ],
    );
  }
}
