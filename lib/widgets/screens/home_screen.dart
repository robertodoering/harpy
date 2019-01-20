import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/timeline_model.dart';
import 'package:harpy/widgets/shared/animations.dart';
import 'package:harpy/widgets/shared/home_drawer.dart';
import 'package:harpy/widgets/shared/scaffolds.dart';
import 'package:harpy/widgets/shared/tweet/tweet_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      appBar: "Harpy",
      body: TweetList<HomeTimelineModel>(),
      drawer: HomeDrawer(),
    );
  }
}

class TweetList<T extends TimelineModel> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<T>(
      builder: (context, oldChild, timelineModel) {
        return _buildList(timelineModel.tweets);
      },
    );
  }

  Widget _buildList(List<Tweet> tweets) {
    return SlideFadeInAnimation(
      offset: const Offset(0.0, 100.0),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: tweets.length,
        itemBuilder: (context, index) {
          return TweetTile(tweets[index]);
        },
        separatorBuilder: (context, index) => Divider(height: 0.0),
      ),
    );
  }
}
