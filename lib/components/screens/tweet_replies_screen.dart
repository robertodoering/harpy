import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/loading_tile.dart';
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
        if (model.parentTweet != null) TweetTile(tweet: model.parentTweet),
        BigTweetTile(tweet: tweet),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context, TweetRepliesModel model) {
    final textTheme = Theme.of(context).textTheme;

    if (model.loading) {
      return const LoadingTweetTile(
        padding: EdgeInsets.fromLTRB(56, 8, 8, 8),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            const Text("No replies found"),
            Text(
              "Only replies of the last 7 days can be retrieved.",
              style: textTheme.body2,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<TweetRepliesModel>(
      builder: (context, model, _) {
        return SlideFadeInAnimation(
          offset: const Offset(0, 100),
          child: TweetList(
            leading: _buildLeading(model),
            placeHolder: _buildPlaceholder(context, model),
            tweets: model.replies,
            onLoadMore: model.loadMore,
            enableLoadMore: !model.lastPage,
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
///
/// Very similar to [TweetTile] at the moment but can be used for a different
/// look of the 'parent' tweet.
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
        const Divider(height: 0),
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
