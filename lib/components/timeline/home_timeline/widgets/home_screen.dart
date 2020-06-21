import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/harpy_scaffold.dart';
import 'package:harpy/components/timeline/common/widgets/tweet_timeline.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_bloc.dart';

class HomeScreen extends StatelessWidget {
  static const String route = 'home';

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: 'Harpy',
      showIcon: true,
      body: BlocProvider<HomeTimelineBloc>(
        create: (BuildContext context) => HomeTimelineBloc(),
        child: TweetTimeline<HomeTimelineBloc>(),
      ),
    );
  }
}
