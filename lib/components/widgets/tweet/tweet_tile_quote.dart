import 'package:flutter/material.dart';
import 'package:harpy/components/screens/tweet_replies_screen.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile_content.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:provider/provider.dart';

/// Builds the quoted [Tweet] inside the [TweetTile] if it exists.
class TweetQuote extends StatelessWidget {
  const TweetQuote(this.model);

  final TweetModel model;

  @override
  Widget build(BuildContext context) {
    if (!model.hasQuote) {
      return Container();
    }

    return GestureDetector(
      onTap: () => HarpyNavigator.push(TweetRepliesScreen(
        tweet: model.tweet.quotedStatus,
      )),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ChangeNotifierProvider<TweetModel>(
          builder: (_) => TweetModel(originalTweet: model.quote, isQuote: true),
          child: const _QuoteContent(),
        ),
      ),
    );
  }
}

class _QuoteContent extends StatelessWidget {
  const _QuoteContent();

  @override
  Widget build(BuildContext context) {
    final quoteTweetModel = TweetModel.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TweetNameColumn(quoteTweetModel),
        TweetText(quoteTweetModel),
      ],
    );
  }
}
