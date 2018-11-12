import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/shared/animations.dart';
import 'package:harpy/stores/home_store.dart';
import 'package:harpy/theme.dart';

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

class TweetTile extends StatelessWidget {
  final Tweet tweet;

  TweetTile(this.tweet);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
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

  Widget _buildActionRow() {
    return Row(
      children: <Widget>[
        TweetAction(
          iconData: Icons.chat_bubble_outline,
          value: 69,
          tapColor: Colors.blue,
          onTap: () {},
        ),
        TweetAction(
          iconData: Icons.repeat,
          value: 13,
          tapColor: Colors.green,
          onTap: () {},
        ),
        TweetAction(
          iconData: Icons.favorite_border,
          value: 37,
          tapColor: Colors.red,
          onTap: () {},
        ),
      ],
    );
  }
}

class TweetAction extends StatefulWidget {
  final IconData iconData;
  final int value;
  final Color tapColor;
  final VoidCallback onTap;

  TweetAction({
    this.iconData,
    this.value,
    this.tapColor,
    this.onTap,
  });

  @override
  _TweetActionState createState() => _TweetActionState();
}

class _TweetActionState extends State<TweetAction> {
  bool drawColored = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => setState(() {
            drawColored = true;
          }),
      onTapUp: (_) => setState(() {
            drawColored = false;
          }),
      onTapCancel: () => setState(() {
            drawColored = false;
          }),
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Icon(
              widget.iconData,
              size: 18.0,
              color: drawColored
                  ? widget.tapColor
                  : Theme.of(context).iconTheme.color,
            ),
            SizedBox(width: 8.0),
            Text(
              "${widget.value}",
              style: drawColored
                  ? Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: widget.tapColor)
                  : Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ),
    );
  }
}
