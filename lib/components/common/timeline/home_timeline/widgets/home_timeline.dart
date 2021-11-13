import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class HomeTimeline extends StatelessWidget {
  const HomeTimeline({
    this.refreshIndicatorOffset,
  });

  final double? refreshIndicatorOffset;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeTimelineCubit>();
    final state = cubit.state;

    // we have to explicitly provide a `TimelineCubit` for the `Timeline`
    return BlocProvider<TimelineCubit>.value(
      value: cubit,
      child: Timeline(
        listKey: const PageStorageKey('home_timeline'),
        refreshIndicatorOffset: refreshIndicatorOffset,
        tweetBuilder: (tweet) => HomeTimelineTweetCard(tweet),
        beginSlivers: [
          const HomeTopSliverPadding(),
          if (state.hasTweets) const HomeTimelineTopRow(),
        ],
      ),
    );
  }
}
