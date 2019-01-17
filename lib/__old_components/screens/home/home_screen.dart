import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/__old_components/screens/home/home_drawer.dart';
import 'package:harpy/__old_stores/home_store.dart';
import 'package:harpy/__old_stores/tokens.dart';
import 'package:harpy/widgets/shared/scaffolds.dart';
import 'package:harpy/widgets/shared/tweet_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with StoreWatcherMixin<HomeScreen> {
  HomeStore store;
  bool _requestingMore = false;

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
    return HarpyScaffold(
      appBar: "Harpy",
      body: _buildBody(),
      drawer: HomeDrawer(),
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
        trailing: _buildTrailing(),
        type: ListType.home,
      );
    }
  }

  Widget _buildTrailing() {
    return _requestingMore
        ? SizedBox(
            height: 100.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Loading more tweets..."),
                SizedBox(height: 16.0),
                CircularProgressIndicator(),
              ],
            ),
          )
        : Container();
  }

  Future<void> _onRefresh() async {
    await HomeStore.updateTweets();
  }

  Future<void> _onRequestMore() async {
    setState(() {
      _requestingMore = true;
    });
    await HomeStore.tweetsAfter("${store.tweets.last.id}").then((_) {
      setState(() {
        _requestingMore = false;
      });
    });
  }
}
