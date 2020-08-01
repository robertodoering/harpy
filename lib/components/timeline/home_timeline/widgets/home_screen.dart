import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/harpy_scaffold.dart';
import 'package:harpy/components/timeline/common/widgets/tweet_timeline.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_bloc.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_event.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_drawer.dart';

/// The home screen for an authenticated user.
class HomeScreen extends StatelessWidget {
  static const String route = 'home';

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: 'Harpy',
      showIcon: true,
      drawer: const HomeDrawer(),
      body: BlocProvider<HomeTimelineBloc>(
        create: (BuildContext context) => HomeTimelineBloc(),
        child: TweetTimeline<HomeTimelineBloc>(
          onRefresh: (HomeTimelineBloc bloc) {
            bloc.add(const UpdateHomeTimelineEvent());
            return bloc.updateTimelineCompleter.future;
          },
          onLoadMore: (HomeTimelineBloc bloc) {
            bloc.add(const RequestMoreHomeTimelineEvent());
            return bloc.requestMoreCompleter.future;
          },
        ),
      ),
    );
  }
}
