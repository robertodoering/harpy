import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/cached_circle_avatar.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/created_at_time.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds the tweet author's avatar, display name, username and the creation
/// date of the tweet.
class TweetAuthorRow extends StatelessWidget {
  const TweetAuthorRow(
    this.tweet, {
    this.avatarRadius = defaultAvatarRadius,
    this.fontSizeDelta = 0,
    this.iconSize = 16,
  });

  final TweetData tweet;

  final double avatarRadius;

  final double fontSizeDelta;

  final double iconSize;

  static const double defaultAvatarRadius = 22;

  void _onUserTap(BuildContext context) {
    app<HarpyNavigator>().pushUserProfile(
      currentRoute: ModalRoute.of(context).settings,
      screenName: tweet.userData.screenName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => _onUserTap(context),
          // todo: avatar should scale based off of the text height
          child: Row(
            children: <Widget>[
              CachedCircleAvatar(
                imageUrl: tweet.userData.appropriateUserImageUrl,
                radius: avatarRadius,
              ),
              defaultHorizontalSpacer,
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => _onUserTap(context),
                child: Row(
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
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(Icons.verified_user, size: iconSize),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _onUserTap(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        '@${tweet.userData.screenName} \u00b7 ',
                        style: theme.textTheme.bodyText1.apply(
                          fontSizeDelta: fontSizeDelta,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: CreatedAtTime(
                        createdAt: tweet.createdAt,
                        fontSizeDelta: fontSizeDelta,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
