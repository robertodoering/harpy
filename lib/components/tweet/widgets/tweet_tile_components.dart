import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/favorite_button.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
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
                // todo: format created at string
                '@${tweet.userData.screenName} \u00b7 '
                '${tweet.createdAt}',
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

/// Builds the buttons with actions for the [tweet].
class TweetActionRow extends StatelessWidget {
  const TweetActionRow(this.tweet);

  final TweetData tweet;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        HarpyButton.flat(
          onTap: () {},
          icon: Icons.repeat,
          text: '${tweet.retweetCount}',
          foregroundColor: Colors.green,
          iconSize: 20,
          padding: const EdgeInsets.all(8),
        ),
        const SizedBox(width: 8),
        FavoriteButton(
          favorited: true,
          text: '${tweet.favoriteCount}',
          favorite: () {},
          unfavorite: () {},
        ),
        const Spacer(),
        HarpyButton.flat(
          onTap: () {},
          foregroundColor: Colors.blue,
          icon: Icons.translate,
          iconSize: 20,
          padding: const EdgeInsets.all(8),
        ),
      ],
    );
  }
}
