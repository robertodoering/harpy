import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class LikesTimeline extends StatelessWidget {
  const LikesTimeline({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    return Timeline(
      listKey: const PageStorageKey('likes_timeline'),
      provider: likesTimelineProvider(user.id),
    );
  }
}
