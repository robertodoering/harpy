import 'package:flutter/material.dart';

/// Builds a loading widget for a [TweetTimeline].
class TimelineLoading extends StatelessWidget {
  const TimelineLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
