import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class HomeTimeline extends StatelessWidget {
  const HomeTimeline();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<HomeTimelineCubit>();
    final state = cubit.state;

    // we have to explicitly provide a `TimelineCubit` for the `Timeline`
    return BlocProvider<TimelineCubit>.value(
      value: cubit,
      child: Timeline(
        listKey: const PageStorageKey('home_timeline'),
        refreshIndicatorOffset: config.bottomAppBar
            ? 0
            : HomeAppBar.height(context) + config.paddingValue,
        tweetBuilder: (tweet) => HomeTimelineTweetCard(tweet),
        beginSlivers: [
          const HomeTopSliverPadding(),
          if (state.hasTweets) const HomeTimelineTopRow(),
        ],
      ),
    );
  }
}
