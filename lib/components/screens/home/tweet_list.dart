import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/screens/home/tweet_action.dart';
import 'package:harpy/components/shared/animations.dart';
import 'package:harpy/stores/home_store.dart';
import 'package:harpy/theme.dart';

/// The list containing many [TweetTile]s.
class TweetList extends StatelessWidget {
  final List<Tweet> tweets;

  TweetList(this.tweets);

  // todo:
  // to animate new tweets in after a refresh:
  // maybe have 2 list of tweets,
  // wrap the new tweets into a single widget / into a listview
  // set the initial index of the main list view to the old tweets
  // scroll up

  // maybe stay on the old index and scroll up when rebuilding

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: SlideFadeInAnimation(
        offset: const Offset(0.0, 100.0),
        child: ListView.separated(
          itemCount: tweets.length,
          itemBuilder: (context, index) {
            return TweetTile(tweets[index]);
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      ),
      onRefresh: () async {
        await HomeStore.updateTweets();
      },
    );
  }
}

/// A single tile that display information and [TweetAction]s for a [Tweet].
class TweetTile extends StatelessWidget {
  final Tweet tweet;

  TweetTile(this.tweet);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildNameRow(),
          _buildText(),
          _buildActionRow(),
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
            backgroundColor: Colors.transparent,
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

                // middle dot
                Text(
                  " \u00b7 ",
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

  Widget _buildActionRow() {
    return Row(
      children: <Widget>[
        // comment action
        TweetAction(
          active: true,
          inactiveIconData: Icons.chat_bubble_outline,
          activeIconData: Icons.chat_bubble,
          value: 69,
          color: Colors.blue,
          activate: () {},
          deactivate: () {},
        ),

        // retweet action
        TweetAction(
          active: true,
          inactiveIconData: Icons.repeat,
          activeIconData: Icons.repeat,
          value: tweet.retweetCount,
          color: Colors.green,
          activate: () {},
          deactivate: () {},
        ),

        // favorite action
        TweetAction(
          active: false,
          inactiveIconData: Icons.favorite_border,
          activeIconData: Icons.favorite,
          value: tweet.favoriteCount,
          color: Colors.red,
          activate: () {},
          deactivate: () {},
        ),
      ],
    );
  }
}
