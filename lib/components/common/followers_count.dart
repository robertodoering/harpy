import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/core/api/tweet_data.dart';

/// A widget to display the number of following users and followers for the
/// [user].
class FollowersCount extends StatelessWidget {
  const FollowersCount(this.user);

  final UserData user;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.spaceBetween,
      children: <Widget>[
        HarpyButton.flat(
          text: '${user.friendsCount} Following',
          padding: EdgeInsets.zero,
          onTap: () {},
        ),
        HarpyButton.flat(
          text: '${user.followersCount} Followers',
          padding: EdgeInsets.zero,
          onTap: () {},
        ),
      ],
    );
  }
}
