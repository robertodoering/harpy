import 'package:flutter/material.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

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
        const SizedBox(
          width: TweetAuthorRow.defaultAvatarRadius * 2,
          child: Icon(Icons.repeat, size: 18),
        ),
        defaultHorizontalSpacer,
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
