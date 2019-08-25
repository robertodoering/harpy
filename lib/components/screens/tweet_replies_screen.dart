import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/tweet/tweet_list.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile_content.dart';
import 'package:harpy/components/widgets/tweet/tweet_tile_quote.dart';
import 'package:harpy/models/tweet_model.dart';
import 'package:harpy/models/tweet_replies_model.dart';
import 'package:provider/provider.dart';

/// Shows a [Tweet] and all of its replies in a list.
class TweetRepliesScreen extends StatelessWidget {
  const TweetRepliesScreen({
    @required this.tweet,
  });

  final Tweet tweet;

  Widget _buildLeading(TweetRepliesModel model) {
    return Column(
      children: <Widget>[
        if (model.parentTweet != null)
          TweetTile(
            tweet: model.parentTweet,
          ),
        BigTweetTile(tweet: tweet),
      ],
    );
  }

  Widget _buildLoading() {
    return const Padding(
      key: ValueKey<String>("loading"),
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildNoRepliesFound(BuildContext context) {
    return Padding(
      key: const ValueKey<String>("replies"),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          const Text("No replies found"),
          Text(
            "Only replies of the last 7 days can be retrieved.",
            style: Theme.of(context).textTheme.body2,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<TweetRepliesModel>(
      builder: (context, model, _) {
        if (model.loading) {
          return _buildLoading();
        }

        return SlideFadeInAnimation(
          offset: const Offset(0, 100),
          child: TweetList(
            leading: _buildLeading(model),
            placeHolder: _buildNoRepliesFound(context),
            tweets: model.replies,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TweetRepliesModel>(
      builder: (_) => TweetRepliesModel(
        tweet: tweet,
      ),
      child: HarpyScaffold(
        title: "Replies",
        body: _buildBody(context),
      ),
    );
  }
}

/// A [Tweet] displayed in a tile for the [TweetRepliesScreen].
class BigTweetTile extends StatefulWidget {
  const BigTweetTile({
    @required this.tweet,
  });

  final Tweet tweet;

  @override
  _BigTweetTileState createState() => _BigTweetTileState();
}

class _BigTweetTileState extends State<BigTweetTile>
    with SingleTickerProviderStateMixin<BigTweetTile> {
  Widget _buildContent(BuildContext context) {
    final model = TweetModel.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TweetRetweetedRow(model),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TweetAvatarNameRow(model),
              TweetText(model),
              TweetQuote(model),
              TweetTranslation(model, vsync: this),
              TweetMedia(model),
              TweetActionsRow(model),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweetTile.custom(
      tweet: widget.tweet,
      content: Builder(
        builder: _buildContent,
      ),
    );
  }
}
