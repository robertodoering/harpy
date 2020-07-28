import 'package:flutter/material.dart';
import 'package:harpy/components/common/twitter_text.dart';
import 'package:harpy/components/tweet/widgets/media/tweet_media.dart';
import 'package:harpy/components/tweet/widgets/tweet_tile_components.dart';
import 'package:harpy/core/api/tweet_data.dart';

class TweetTile extends StatelessWidget {
  const TweetTile(this.tweet);

  final TweetData tweet;

  Widget _buildReplies(ThemeData theme) {
    final String replyAuthors = tweet.replyAuthors;

    return Card(
      color: theme.brightness == Brightness.dark
          ? Colors.white.withOpacity(.1)
          : Colors.black.withOpacity(.1),
      margin: const EdgeInsets.only(left: 56, right: 8, bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (replyAuthors?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Text(
                '$replyAuthors replied',
                style: theme.textTheme.bodyText1.copyWith(
                  color: theme.textTheme.bodyText1.color.withOpacity(.8),
                  height: 1,
                ),
              ),
            ),
          ...tweet.replies.map(
            (TweetData reply) => _TweetTileContent(reply),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      color: theme.brightness == Brightness.dark
          ? Colors.white.withOpacity(.1)
          : Colors.black.withOpacity(.1),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: <Widget>[
          _TweetTileContent(tweet),
          if (tweet.replies.isNotEmpty) _buildReplies(theme),
        ],
      ),
    );
  }
}

/// Builds the content for a tweet.
class _TweetTileContent extends StatelessWidget {
  const _TweetTileContent(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> content = <Widget>[
      if (tweet.isRetweet) TweetRetweetedRow(tweet),
      TweetAuthorRow(tweet),
      if (tweet.hasText)
        TwitterText(
          tweet.fullText,
          entities: tweet.entities,
          entityColor: theme.accentColor,
          urlToIgnore: tweet.quotedStatusUrl,
        ),
      if (tweet.hasMedia) TweetMedia(tweet),
      if (tweet.hasQuote) _TweetQuoteContent(tweet.quote),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (Widget child in content) ...<Widget>[
            child,
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

/// Builds the content for a tweet quote.
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

    final List<Widget> content = <Widget>[
      TweetQuoteAuthorRow(tweet),
      if (tweet.hasText)
        TwitterText(
          tweet.fullText,
          entities: tweet.entities,
          entityColor: theme.accentColor,
          style: theme.textTheme.bodyText2.apply(fontSizeDelta: -2),
          urlToIgnore: tweet.quotedStatusUrl,
        ),
      if (tweet.hasMedia) TweetMedia(tweet),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(.2)),
      ),
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (Widget child in content) ...<Widget>[
            child,
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
