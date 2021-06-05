import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

/// Builds the tweet author's avatar, display name, username and the creation
/// date of the tweet.
class TweetAuthorRow extends StatelessWidget {
  const TweetAuthorRow(
    this.user, {
    this.createdAt,
    this.enableUserTap = true,
    this.avatarRadius = defaultAvatarRadius,
    this.avatarPadding,
    this.fontSizeDelta = 0,
    this.iconSize = 16,
  });

  final UserData user;

  final DateTime? createdAt;

  final bool enableUserTap;

  final double avatarRadius;

  /// The horizontal padding between the avatar and the username.
  ///
  /// Defaults to the [defaultPaddingValue] if `null`.
  final double? avatarPadding;

  final double fontSizeDelta;

  final double iconSize;

  static const double defaultAvatarRadius = 22;

  void _onUserTap(BuildContext context) {
    if (enableUserTap) {
      app<HarpyNavigator>().pushUserProfile(
        currentRoute: ModalRoute.of(context)!.settings,
        screenName: user.handle,
      );
    }
  }

  Widget _buildAvatar(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onUserTap(context),
      // todo: avatar should scale based off of the text height
      child: Row(
        children: <Widget>[
          HarpyCircleAvatar(
            imageUrl: user.appropriateUserImageUrl,
            radius: avatarRadius,
          ),
          AnimatedContainer(
            duration: kShortAnimationDuration,
            width: avatarPadding ?? defaultPaddingValue,
          ),
        ],
      ),
    );
  }

  Widget _buildScreenName(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: () => _onUserTap(context),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Text(
              user.name,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyText2!.apply(
                fontSizeDelta: fontSizeDelta,
              ),
            ),
          ),
          if (user.verified)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(CupertinoIcons.checkmark_seal_fill, size: iconSize),
            ),
        ],
      ),
    );
  }

  Widget _buildUserName(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: () => _onUserTap(context),
      child: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: '@${user.handle}',
              style: theme.textTheme.bodyText1!.apply(
                fontSizeDelta: fontSizeDelta,
              ),
            ),
            if (createdAt != null) ...<InlineSpan>[
              TextSpan(
                text: ' \u00b7 ',
                style: theme.textTheme.bodyText1!.apply(
                  fontSizeDelta: fontSizeDelta,
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: CreatedAtTime(
                  createdAt: createdAt,
                  fontSizeDelta: fontSizeDelta,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildAvatar(context),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildScreenName(context, theme),
              _buildUserName(context, theme),
            ],
          ),
        ),
      ],
    );
  }
}
