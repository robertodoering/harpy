import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile_content.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:scoped_model/scoped_model.dart';

/// Builds the quoted [Tweet] inside the [TweetTile] if it exists.
class TweetQuote extends StatelessWidget {
  const TweetQuote(this.model);

  final TweetModel model;

  @override
  Widget build(BuildContext context) {
    if (!model.isQuote) {
      return Container();
    }

    TweetModel quoteTweetModel = TweetModel(
      originalTweet: model.quote,
      homeTimelineCache: model.homeTimelineCache,
      userTimelineCache: model.userTimelineCache,
      homeTimelineModel: model.homeTimelineModel,
      userTimelineModel: model.userTimelineModel,
      tweetService: model.tweetService,
      translationService: model.translationService,
    )
      ..quoted = true
      ..limitText();

    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ScopedModel<TweetModel>(
        model: quoteTweetModel,
        child: _QuoteContent(),
      ),
    );
  }
}

class _QuoteContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = TweetModel.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TweetNameColumn(model),
        TweetText(model),
      ],
    );
  }
}
