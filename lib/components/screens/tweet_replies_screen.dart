import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/components/widgets/shared/animations.dart';
import 'package:harpy/components/widgets/shared/cache_provider.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
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

  Widget _buildBody() {
    return Consumer<TweetRepliesModel>(
      builder: (context, model, _) {
        if (model.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SlideFadeInAnimation(
          offset: const Offset(0, 100),
          child: CustomTweetListView(
            content: [
              BigTweetTile(tweet: tweet),
              ...model.replies,
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);

    return CacheProvider(
      homeTimelineCache: serviceProvider.data.homeTimelineCache,
      child: ChangeNotifierProvider<TweetRepliesModel>(
        builder: (_) => TweetRepliesModel(
          tweet: tweet,
          tweetSearchService: serviceProvider.data.tweetSearchService,
        ),
        child: HarpyScaffold(
          title: "Replies",
          body: _buildBody(),
        ),
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
    return TweetTile(
      tweet: widget.tweet,
      content: Builder(
        builder: _buildContent,
      ),
    );
  }
}
