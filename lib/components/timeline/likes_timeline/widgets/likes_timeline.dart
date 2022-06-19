import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class LikesTimeline extends ConsumerWidget {
  const LikesTimeline({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final general = ref.watch(generalPreferencesProvider);

    return Timeline(
      listKey: general.restoreScrollPositions
          ? const PageStorageKey('likes_timeline')
          : null,
      provider: likesTimelineProvider(user.id),
    );
  }
}
