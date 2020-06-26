import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';

/// A widget to display the number of following users and followers for the
/// [user].
class FollowersCount extends StatelessWidget {
  const FollowersCount();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.spaceBetween,
      children: <Widget>[
        HarpyButton.flat(
          text: '123 Following',
          padding: EdgeInsets.zero,
          onTap: () {},
        ),
        HarpyButton.flat(
          text: '123 Followers',
          padding: EdgeInsets.zero,
          onTap: () {},
        ),
      ],
    );
  }
}
