import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/components/screens/home/home_drawer.dart';
import 'package:harpy/components/shared/tweet_list.dart';
import 'package:harpy/stores/home_store.dart';
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
            style: HarpyTheme.theme.textTheme.title.copyWith(fontSize: 20.0),
          ),
        ),
        body: _buildBody(),
        drawer: HomeDrawer(),
      ),
    );
  }

  Widget _buildBody() {
    if (store.tweets == null) {
      return Center(child: Text("no tweets ;w;"));
    } else {
      return TweetList(
        tweets: store.tweets,
        onRefresh: _onRefresh,
        onRequestMore: _onRequestMore,
      );
    }
  }

  Future<void> _onRefresh() async {
    await HomeStore.updateTweets();
  }

  Future<void> _onRequestMore() async {
    await HomeStore.tweetsAfter("${store.tweets.last.id}").then((_) {
      setState(() {});
    });
  }
}
