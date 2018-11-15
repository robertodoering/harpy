import 'package:flutter/material.dart';
import 'package:harpy/components/screens/main/main_screen.dart';
import 'package:harpy/stores/login_store.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildDrawerHeader(context),
          _buildActions(),
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: double.infinity),
          CircleAvatar(
            radius: 32.0,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text("no u"),
          ),
          SizedBox(height: 8.0),
          Text("Your Name", style: Theme.of(context).textTheme.display2),
          Text("@yourname", style: Theme.of(context).textTheme.display1),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.face),
          title: Text("Profile"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.bookmark_border),
          title: Text("Bookmarks"),
          onTap: () {},
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
