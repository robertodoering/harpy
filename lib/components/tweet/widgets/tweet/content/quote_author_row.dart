import 'package:flutter/material.dart';
import 'package:harpy/components/common/cached_circle_avatar.dart';
import 'package:harpy/core/api/tweet_data.dart';
import 'package:harpy/misc/utils/string_utils.dart';

/// Builds the author row for a quote similar to [TweetAuthorRow].
class TweetQuoteAuthorRow extends StatelessWidget {
  const TweetQuoteAuthorRow(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    const double fontSizeDelta = -2;

    return Row(
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
                        fontSizeDelta: fontSizeDelta,
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
                '@${tweet.userData.screenName} \u00b7 '
                '${tweetTimeDifference(tweet.createdAt)}',
                style: theme.textTheme.bodyText1.apply(
                  fontSizeDelta: fontSizeDelta,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }
}
