import 'package:flutter/material.dart';
import 'package:harpy/components/tweet/widgets/tweet/tweet_tile.dart';
import 'package:harpy/core/api/tweet_data.dart';

/// Builds [TweetTile]s for the replies in [tweet].
///
/// [TweetData.replyAuthors] are built above the [TweetTile]s if they exist.
class TweetReplies extends StatelessWidget {
  const TweetReplies(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (tweet.replyAuthors?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    // same width as avatar with padding
                    width: 40,
                    child: Icon(Icons.reply, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${tweet.replyAuthors} replied',
                    style: theme.textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ...tweet.replies.map(
            (TweetData reply) => Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 8),
              child: TweetTile(reply),
            ),
          ),
        ],
      ),
    );
  }
}
