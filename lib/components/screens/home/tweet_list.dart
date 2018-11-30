import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/screens/home/tweet_action.dart';
import 'package:harpy/components/screens/home/tweet_text.dart';
import 'package:harpy/components/shared/animations.dart';
import 'package:harpy/stores/home_store.dart';
import 'package:harpy/theme.dart';
import 'package:intl/intl.dart';

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
    String time;
    Duration timeDifference = DateTime.now().difference(tweet.createdAt);
    if (timeDifference.inHours <= 24) {
      time = "${timeDifference.inHours}h";
    } else {
      time = DateFormat("MMMd").format(tweet.createdAt);
    }

    return Row(
      children: <Widget>[
        // avatar
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(
              tweet.user.userProfileImageOriginal,
            ),
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // name
            Text(tweet.user.name),

            // username · time since tweet in hours
            Text(
              "@${tweet.user.screenName} \u00b7 $time",
              style: HarpyTheme.theme.textTheme.caption,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildText() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TwitterText(
        text: tweet.full_text,
        entities: tweet.entities,
      ),
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: <Widget>[
        // retweet action
        TweetAction(
          active: tweet.retweeted,
          inactiveIconData: Icons.repeat,
          activeIconData: Icons.repeat,
          value: tweet.retweetCount,
          color: Colors.green,
          activate: () => HomeStore.retweetTweet(tweet),
          deactivate: () => HomeStore.unretweetTweet(tweet),
        ),

        // favorite action
        TweetAction(
          active: tweet.favorited,
          inactiveIconData: Icons.favorite_border,
          activeIconData: Icons.favorite,
          value: tweet.favoriteCount,
          color: Colors.red,
          activate: () => HomeStore.favoriteTweet(tweet),
          deactivate: () => HomeStore.unfavoriteTweet(tweet),
        ),
      ],
    );
  }
}
