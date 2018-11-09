import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/stores/home_store.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with StoreWatcherMixin<HomeScreen> {
  HomeStore store;

  @override
  void initState() {
    super.initState();

    store = listenToStore(homeStoreToken);

    HomeStore.refreshTweets();
  }

  @override
  void dispose() {
    super.dispose();

    unlistenFromStore(store);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("woop"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (store.tweets == null) {
      return Center(child: Text("no tweets"));
    } else {
      return ListView(
        children: store.tweets.map((tweet) {
          return ListTile(
            leading: Text(tweet.user.name),
            subtitle: Text(tweet.text),
          );
        }).toList(),
      );
    }
  }
}
