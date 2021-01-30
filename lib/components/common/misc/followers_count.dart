import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
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
          text: Text('${_numberFormat.format(user.friendsCount)} following'),
          padding: EdgeInsets.zero,
          onTap: () => app<HarpyNavigator>().pushFollowingScreen(
            userId: user.idStr,
          ),
        ),
        HarpyButton.flat(
          text: Text('${_numberFormat.format(user.followersCount)} followers'),
          padding: EdgeInsets.zero,
          onTap: () => app<HarpyNavigator>().pushFollowersScreen(
            userId: user.idStr,
          ),
        ),
      ],
    );
  }
}
