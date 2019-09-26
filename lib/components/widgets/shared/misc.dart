import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/screens/following_followers_screen.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/core/utils/string_utils.dart';

/// An [IconRow] to display an [Icon] next to some text.
class IconRow extends StatelessWidget {
  const IconRow({
    @required this.icon,
    @required this.child,
    this.iconPadding,
  });

  /// The [IconData] of the icon.
  final IconData icon;

  /// The [child] an either be a Widget or a String that will turn into a text
  /// widget and is displayed to the right of the [icon].
  final dynamic child;

  /// If [iconPadding] is not null the [icon] will be in the center of a
  /// [SizedBox] with a width of [iconPadding].
  final double iconPadding;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.body1;

    return Row(
      children: <Widget>[
        SizedBox(
          width: iconPadding,
          child: Icon(icon, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: child is Widget
              ? child
              : Text(
                  child,
                  style: textStyle.copyWith(
                    color: textStyle.color.withOpacity(0.8),
                  ),
                ),
        ),
      ],
    );
  }
}

/// A Widget to display the number of following users and followers for the
/// [User].
class FollowersCount extends StatelessWidget {
  const FollowersCount(this.user);

  final User user;

  void _showInScreen(FollowingFollowerType type) {
    HarpyNavigator.push(FollowingFollowerScreen(
      user: user,
      type: type,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.spaceBetween,
      children: <Widget>[
        HarpyButton.flat(
          text: "${prettyPrintNumber(user.friendsCount)} Following",
          padding: EdgeInsets.zero,
          onTap: () => _showInScreen(FollowingFollowerType.following),
        ),
        HarpyButton.flat(
          text: "${prettyPrintNumber(user.followersCount)} Followers",
          padding: EdgeInsets.zero,
          onTap: () => _showInScreen(FollowingFollowerType.followers),
        ),
      ],
    );
  }
}
