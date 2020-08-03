import 'package:flutter/material.dart';
import 'package:harpy/core/api/tweet_data.dart';

/// Builds a row with the retweeter's display name indicating that a tweet is a
/// retweet.
class TweetRetweetedRow extends StatelessWidget {
  const TweetRetweetedRow(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        SizedBox(
          // same width as avatar with padding
          width: 40,
          child: Icon(Icons.repeat, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${tweet.retweetUserName} retweeted',
            style: theme.textTheme.bodyText2.copyWith(
              color: theme.textTheme.bodyText2.color.withOpacity(.8),
            ),
          ),
        ),
      ],
    );
  }
}
