import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile_content.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/models/timeline_model.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:harpy/models/user_timeline_model.dart';
import 'package:provider/provider.dart';

class TweetTile extends StatelessWidget {
  TweetTile({
    @required this.tweet,
    Key key,
  })  : content = TweetTileContent(),
        super(key: key);

  const TweetTile.custom({
    @required this.tweet,
    @required this.content,
    Key key,
  }) : super(key: key);

  final Tweet tweet;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final loginModel = LoginModel.of(context);
    final homeTimelineModel = HomeTimelineModel.of(context);
    OnTweetUpdated onTweetUpdated;

    TimelineModel timelineModel;

    try {
      // use the user timeline model if it exists above the home timeline model
      timelineModel = UserTimelineModel.of(context);

      // make sure tweets in the home timeline get updated when updating a
      // tweet in the user timeline
      onTweetUpdated = homeTimelineModel.updateTweet;
    } on ProviderNotFoundError {
      timelineModel = homeTimelineModel;
    }

    // todo: on update, update home timeline tweet

    return ChangeNotifierProvider<TweetModel>(
      create: (_) => TweetModel(
        loginModel: loginModel,
        originalTweet: tweet,
        onTweetUpdated: onTweetUpdated,
        timelineModel: timelineModel,
      )..replyAuthors = timelineModel.findTweetReplyAuthors(tweet),
      child: content,
    );
  }
}
