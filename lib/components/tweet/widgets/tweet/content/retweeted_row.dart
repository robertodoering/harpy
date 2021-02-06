import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Builds a row with the retweeter's display name indicating that a tweet is a
/// retweet.
class TweetRetweetedRow extends StatelessWidget {
  const TweetRetweetedRow(this.tweet);

  final TweetData tweet;

  void _onRetweeterTap(BuildContext context) {
    app<HarpyNavigator>().pushUserProfile(
      currentRoute: ModalRoute.of(context).settings,
      screenName: tweet.retweetScreenName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _onRetweeterTap(context),
      child: Row(
        children: <Widget>[
          AnimatedContainer(
            duration: kShortAnimationDuration,
            width: TweetAuthorRow.defaultAvatarRadius * 2,
            child: const Icon(FeatherIcons.repeat, size: 16),
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
      ),
    );
  }
}
