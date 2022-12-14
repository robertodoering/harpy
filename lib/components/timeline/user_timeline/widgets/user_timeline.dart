import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class UserTimeline extends StatelessWidget {
  const UserTimeline({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    return Timeline(
      provider: userTimelineProvider(user.id),
      listKey: PageStorageKey('user_timeline_${user.id}'),
      beginSlivers: [UserTimelineTopActions(user: user)],
      onChangeFilter: () => context.pushNamed(
        UserTimelineFilter.name,
        params: {'handle': user.handle},
        extra: user,
      ),
    );
  }
}
