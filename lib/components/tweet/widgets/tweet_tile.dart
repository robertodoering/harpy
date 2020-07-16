import 'package:flutter/material.dart';
import 'package:harpy/components/common/cached_circle_avatar.dart';
import 'package:harpy/components/common/twitter_text.dart';
import 'package:harpy/components/tweet/widgets/tweet_tile_components.dart';
import 'package:harpy/core/api/tweet_data.dart';

class TweetTile extends StatelessWidget {
  const TweetTile(this.tweet);

  final TweetData tweet;

  List<Widget> _buildReplies() {
    return tweet.replies.map((TweetData tweet) {
      return Column(
        children: <Widget>[
          const Text('reply'),
          Padding(
            padding: const EdgeInsets.only(left: 48),
            child: _TweetTileContent(tweet),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      color: theme.brightness == Brightness.dark
          ? Colors.white.withOpacity(.1)
          : Colors.black.withOpacity(.1),
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: <Widget>[
          _TweetTileContent(tweet),
          if (tweet.replies.isNotEmpty) ..._buildReplies(),
        ],
      ),
    );
  }
}

class _TweetTileContent extends StatelessWidget {
  const _TweetTileContent(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (tweet.isRetweet)
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: TweetRetweetedRow(tweet),
          ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TweetAuthorRow(tweet),
        ),
        if (tweet.hasText)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TwitterText(
              tweet.fullText,
              entities: tweet.entities,
              entityColor: theme.accentColor,
              urlToIgnore: tweet.quotedStatusUrl,
            ),
          ),
        if (tweet.hasQuote) ...<Widget>[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _TweetQuoteContent(tweet.quote),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}

class _TweetQuoteContent extends StatelessWidget {
  const _TweetQuoteContent(
    this.tweet, {
    this.fontSizeDelta = -2,
  });

  final TweetData tweet;

  final int fontSizeDelta;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // todo: change tweet quote style
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              left: 8,
              right: 8,
              bottom: 4,
            ),
            child: Row(
              children: <Widget>[
                CachedCircleAvatar(
                  imageUrl: tweet.userData.profileImageUrlHttps,
                  radius: 14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              tweet.userData.name,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyText2.apply(
                                fontSizeDelta: -2,
                              ),
                            ),
                          ),
                          if (tweet.userData.verified)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(Icons.verified_user, size: 14),
                            ),
                        ],
                      ),
                      Text(
                        // todo: format created at string
                        '@${tweet.userData.screenName} \u00b7 '
                        '${tweet.createdAt}',
                        style: theme.textTheme.bodyText1.apply(
                          fontSizeDelta: -2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (tweet.hasText)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TwitterText(
                tweet.fullText,
                entities: tweet.entities,
                entityColor: theme.accentColor,
                style: theme.textTheme.bodyText2.apply(
                  fontSizeDelta: -2,
                ),
                urlToIgnore: tweet.quotedStatusUrl,
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
