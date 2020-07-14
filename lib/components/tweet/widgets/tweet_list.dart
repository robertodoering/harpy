import 'package:flutter/material.dart';
import 'package:harpy/components/common/scroll_direction_listener.dart';
import 'package:harpy/components/common/scroll_to_start.dart';
import 'package:harpy/components/tweet/widgets/tweet_tile.dart';
import 'package:harpy/core/api/tweet_data.dart';

class TweetList extends StatelessWidget {
  const TweetList(this.tweets);

  final List<TweetData> tweets;

  @override
  Widget build(BuildContext context) {
    return ScrollDirectionListener(
      child: ScrollToStart(
        child: ListView.separated(
          itemCount: tweets.length,
          itemBuilder: (BuildContext context, int index) =>
              TweetTile(tweets[index]),
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(color: Colors.white),
        ),
      ),
    );
  }
}
