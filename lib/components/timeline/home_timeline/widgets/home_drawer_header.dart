import 'package:flutter/material.dart';
import 'package:harpy/components/common/followers_count.dart';

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
          const SizedBox(
            width: double.infinity,
            child: FollowersCount(),
          ),
        ],
      ),
    );
  }
}
