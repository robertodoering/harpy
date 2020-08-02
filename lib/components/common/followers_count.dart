import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/core/api/user_data.dart';
import 'package:intl/intl.dart';

/// A widget to display the number of following users and followers for the
/// [user].
class FollowersCount extends StatelessWidget {
  FollowersCount(this.user);

  final UserData user;

  final NumberFormat _numberFormat = NumberFormat.compact();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.spaceBetween,
      children: <Widget>[
        HarpyButton.flat(
          text: '${_numberFormat.format(user.friendsCount)} Following',
          padding: EdgeInsets.zero,
          onTap: () {},
        ),
        HarpyButton.flat(
          text: '${_numberFormat.format(user.followersCount)} Followers',
          padding: EdgeInsets.zero,
          onTap: () {},
        ),
      ],
    );
  }
}
