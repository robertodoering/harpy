import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class HomeTimelineFilter extends StatelessWidget {
  const HomeTimelineFilter();

  static const name = 'home_timeline_filter';

  @override
  Widget build(BuildContext context) {
    return TimelineFilterSelection(
      provider: homeTimelineFilterProvider,
    );
  }
}
