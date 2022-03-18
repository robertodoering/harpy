import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class LikesTimeline extends StatelessWidget {
  const LikesTimeline({
    required this.user,
    this.scrollPosition = 0,
  });

  final UserData user;
  final int scrollPosition;

  @override
  Widget build(BuildContext context) {
    return Timeline(
      provider: likesTimelineProvider(user.id),
      scrollPosition: scrollPosition,
    );
  }
}
