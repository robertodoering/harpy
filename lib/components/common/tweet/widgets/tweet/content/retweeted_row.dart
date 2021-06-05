import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

/// Builds a row with the retweeter's display name indicating that a tweet is a
/// retweet.
class TweetRetweetedRow extends StatelessWidget {
  const TweetRetweetedRow(this.tweet);

  final TweetData tweet;

  void _onRetweeterTap(BuildContext context) {
    app<HarpyNavigator>().pushUserProfile(
      currentRoute: ModalRoute.of(context)!.settings,
      screenName: tweet.retweetUserHandle!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              style: theme.textTheme.bodyText2!.copyWith(
                color: theme.textTheme.bodyText2!.color!.withOpacity(.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
