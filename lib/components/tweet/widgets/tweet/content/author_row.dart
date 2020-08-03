import 'package:flutter/material.dart';
import 'package:harpy/components/common/cached_circle_avatar.dart';
import 'package:harpy/core/api/tweet_data.dart';
import 'package:harpy/misc/utils/string_utils.dart';

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
                  '@${tweet.userData.screenName} \u00b7 '
                  '${tweetTimeDifference(tweet.createdAt)}',
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
