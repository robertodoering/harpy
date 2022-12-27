import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class UserPageConnections extends StatelessWidget {
  const UserPageConnections({
    required this.user,
    required this.relationship,
    required this.isAuthenticatedUser,
  });

  final UserData user;
  final RelationshipData? relationship;
  final bool isAuthenticatedUser;

  @override
  Widget build(BuildContext context) {
    final enableTap = isAuthenticatedUser ||
        !user.isProtected ||
        (relationship?.following ?? true);

    return Row(
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: ConnectionCount(
              count: user.followingCount,
              builder: (count) => RbyButton.transparent(
                label: Text('$count following'),
                onTap: enableTap
                    ? () => context.pushNamed(
                          FollowingPage.name,
                          params: {'handle': user.handle},
                        )
                    : null,
              ),
            ),
          ),
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerEnd,
            child: ConnectionCount(
              count: user.followersCount,
              builder: (count) => RbyButton.transparent(
                label: Text('$count followers'),
                onTap: enableTap
                    ? () => context.pushNamed(
                          FollowersPage.name,
                          params: {'handle': user.handle},
                        )
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
