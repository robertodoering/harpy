import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/components/screens/home/tweet_list.dart';
import 'package:harpy/components/screens/main/main_screen.dart';
import 'package:harpy/stores/home_store.dart';
import 'package:harpy/stores/login_store.dart';
import 'package:harpy/stores/tokens.dart';
import 'package:harpy/theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with StoreWatcherMixin<HomeScreen> {
  HomeStore store;

  @override
  void initState() {
    super.initState();

    store = listenToStore(Tokens.home);
  }

  @override
  void dispose() {
    super.dispose();

    unlistenFromStore(store);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HarpyTheme.theme,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Harpy",
            style: HarpyTheme.theme.textTheme.title.copyWith(
              fontSize: 20.0,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: HomeStore.clearCache,
            )
          ],
        ),
        body: _buildBody(),
        drawer: HarpyDrawer(),
      ),
    );
  }

  Widget _buildBody() {
    if (store.tweets == null) {
      return Center(child: Text("no tweets ;w;"));
    } else {
      return TweetList(store.tweets);
    }
  }
}

class HarpyDrawer extends StatelessWidget {
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
            backgroundColor: HarpyTheme.primaryColor,
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
