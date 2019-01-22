import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/models/timeline_model.dart';
import 'package:harpy/widgets/shared/animations.dart';
import 'package:harpy/widgets/shared/tweet/tweet_tile.dart';
import 'package:scoped_model/scoped_model.dart';

/// The list of [TweetTile] for a [TimelineModel].
///
/// If [leading] is not `null` it will be placed at the start of the list.
///
/// todo: implement request more
class TweetList<T extends TimelineModel> extends StatelessWidget {
  const TweetList({
    this.leading,
  });

  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<T>(
      builder: (context, oldChild, TimelineModel timelineModel) {
        return RefreshIndicator(
          onRefresh: timelineModel.updateTweets,
          child: _buildList(context, timelineModel, timelineModel.tweets),
        );
      },
    );
  }

  Widget _buildList(
    BuildContext context,
    TimelineModel model,
    List<Tweet> tweets,
  ) {
    List content = [];
    if (leading != null) content.add(leading);
    content.addAll(tweets);
    if (model.requestingMore) content.add(_buildTrailing());

    return SlideFadeInAnimation(
      offset: const Offset(0.0, 100.0),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: tweets.length,
        itemBuilder: (context, index) {
          if (content[index] is Tweet) {
            Tweet tweet = content[index];

            return TweetTile(
              key: Key(tweet.idStr),
              tweet: tweet,
            );
          } else {
            return content[index];
          }
        },
        separatorBuilder: (context, index) => Divider(height: 0.0),
      ),
    );
  }

  Widget _buildTrailing() {
    return SizedBox(
      height: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Loading more tweets..."),
          SizedBox(height: 16.0),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
