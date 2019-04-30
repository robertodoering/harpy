import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/cache_provider.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile_content.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:scoped_model/scoped_model.dart';

class TweetTile extends StatefulWidget {
  const TweetTile({
    Key key,
    this.tweet,
  }) : super(key: key);

  final Tweet tweet;

  @override
  TweetTileState createState() => TweetTileState();
}

class TweetTileState extends State<TweetTile> {
  TweetModel tweetModel;

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);
    final cacheProvider = CacheProvider.of(context);

    // create the tweet model once
    tweetModel ??= TweetModel(
      originalTweet: widget.tweet,
      homeTimelineCache: cacheProvider.homeTimelineCache,
      userTimelineCache: cacheProvider.userTimelineCache,
      tweetService: serviceProvider.data.tweetService,
      translationService: serviceProvider.data.translationService,
    );

    return ScopedModel<TweetModel>(
      model: tweetModel,
      child: SlideFadeInAnimation(
        duration: const Duration(milliseconds: 500),
        child: ScopedModelDescendant<TweetModel>(
          builder: (context, _, model) {
            // the content of the tweet tile that rebuilds when the tweet
            // model notifies its listeners
            return TweetTileContent();
          },
        ),
      ),
    );
  }
}
