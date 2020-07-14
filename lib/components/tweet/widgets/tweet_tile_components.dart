import 'package:flutter/material.dart';
import 'package:harpy/components/common/cached_circle_avatar.dart';
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
          width: 40,
          child: Icon(Icons.repeat, size: 18),
        ),
        const SizedBox(width: 8),
        Text(
          '${tweet.retweetUserName} retweeted',
          style: theme.textTheme.bodyText2.copyWith(
            color: theme.textTheme.bodyText2.color.withOpacity(.8),
          ),
        ),
      ],
    );
  }
}

/// Builds the tweet author's avatar, display name, username and the creation
/// date of the tweet.
class TweetAuthorRow extends StatelessWidget {
  const TweetAuthorRow(this.tweet);

  final TweetData tweet;

  void _onUserTap() {
    // todo: go to user screen
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: _onUserTap,
          child: CachedCircleAvatar(
            imageUrl: tweet.userData.profileImageUrlHttps,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _onUserTap,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        tweet.userData.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (tweet.userData.verified)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.verified_user, size: 16),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _onUserTap,
                child: Text(
                  // todo: format created at string
                  '@${tweet.userData.screenName} \u00b7 ${tweet.createdAt}',
                  style: theme.textTheme.bodyText1,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
