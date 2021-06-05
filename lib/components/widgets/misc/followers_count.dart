import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
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
            userId: user.id,
          ),
        ),
        HarpyButton.flat(
          text: Text('${_numberFormat.format(user.followersCount)} followers'),
          padding: EdgeInsets.zero,
          onTap: () => app<HarpyNavigator>().pushFollowersScreen(
            userId: user.id,
          ),
        ),
      ],
    );
  }
}
