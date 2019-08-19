import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:harpy/models/user_timeline_model.dart';
import 'package:provider/provider.dart';

class TweetTile extends StatelessWidget {
  const TweetTile({
    @required this.tweet,
    @required this.content,
    Key key,
  }) : super(key: key);

  final Tweet tweet;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    // todo: remove timeline dependencies in tweet model
    final homeTimelineModel = HomeTimelineModel.of(context);
    UserTimelineModel userTimelineModel;
    try {
      userTimelineModel = UserTimelineModel.of(context);
    } on ProviderNotFoundError {
      // ignore
    }

    return ChangeNotifierProvider<TweetModel>(
      builder: (_) => TweetModel(
        originalTweet: tweet,
        homeTimelineModel: homeTimelineModel,
        userTimelineModel: userTimelineModel,
      ),
      child: content,
    );
  }
}
