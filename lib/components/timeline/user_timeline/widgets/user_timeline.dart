import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class UserTimeline extends ConsumerWidget {
  const UserTimeline({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return Timeline(
      provider: userTimelineProvider(user.id),
      listKey: PageStorageKey('user_timeline_${user.id}'),
      beginSlivers: [UserTimelineTopActions(user: user)],
      onChangeFilter: () => router.pushNamed(
        UserTimelineFilter.name,
        params: {'handle': user.handle},
        extra: user,
      ),
    );
  }
}
