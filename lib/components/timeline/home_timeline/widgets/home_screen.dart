import 'package:flutter/material.dart';
import 'package:harpy/components/common/harpy_scaffold.dart';
import 'package:harpy/components/timeline/common/widgets/tweet_timeline.dart';

class HomeScreen extends StatelessWidget {
  static const String route = 'home';

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: 'Harpy',
      showIcon: true,
      body: TweetTimeline(),
    );
  }
}
