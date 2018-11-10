import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
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
            style: HarpyTheme.theme.textTheme.title.copyWith(
              fontSize: 20.0,
            ),
          ),
        ),
        body: _buildBody(),
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

class TweetList extends StatelessWidget {
  final List<Tweet> tweets;

  TweetList(this.tweets);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: ListView.separated(
        itemCount: tweets.length,
        itemBuilder: (context, index) {
          return TweetTile(tweets[index]);
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
      onRefresh: () async {
        await HomeStore.updateTweets();
      },
    );
  }
}

class TweetTile extends StatelessWidget {
  final Tweet tweet;

  TweetTile(this.tweet);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          _buildNameRow(),
          _buildText(),
        ],
      ),
    );
  }

  Widget _buildNameRow() {
    return Row(
      children: <Widget>[
        // avatar
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            backgroundImage: Image.network(tweet.user.profileImageUrl).image,
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // name
            Text(tweet.user.name),

            Row(
              children: <Widget>[
                // username
                Text(
                  "@${tweet.user.screenName}",
                  style: HarpyTheme.theme.textTheme.caption,
                ),

                Text(
                  " \u00b7 ", // middle dot
                  style: HarpyTheme.theme.textTheme.caption,
                ),

                // date // todo: get actual created at date
                Text(
                  "${DateTime.now().difference(DateTime.now().subtract(Duration(hours: 3))).inHours}h",
                  style: HarpyTheme.theme.textTheme.caption,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildText() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(tweet.text),
    );
  }
}
