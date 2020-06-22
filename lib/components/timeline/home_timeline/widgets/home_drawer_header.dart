import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';

class HomeDrawerHeader extends StatelessWidget {
  const HomeDrawerHeader();

  Widget _buildAvatarRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // circle avatar
        GestureDetector(
          onTap: () {},
          child: const CircleAvatar(
            radius: 32,
            child: Text('rd'),
          ),
        ),

        const SizedBox(width: 16),

        // name + username
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Text(
                  'name',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {},
                child: Text(
                  '@screenName',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.fromLTRB(
        16,
        16 + MediaQuery.of(context).padding.top, // + statusbar height
        16,
        8,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAvatarRow(context),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FollowersCount(),
          ),
        ],
      ),
    );
  }
}

// todo: move widget
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
