import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class HomeMediaTimeline extends StatelessWidget {
  const HomeMediaTimeline();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeTimelineCubit>();
    final state = cubit.state;

    return ChangeNotifierProvider<MediaTimelineModel>(
      create: (_) => MediaTimelineModel(
        initialTweets: state.tweets.toList(),
      ),
      child: BlocListener<HomeTimelineCubit, TimelineState>(
        listener: (context, state) {
          context.read<MediaTimelineModel>().updateEntries(
                state.tweets.toList(),
              );
        },
        child: ScrollToStart(
          child: LoadMoreListener(
            listen: state.canLoadMore,
            onLoadMore: cubit.loadOlder,
            child: MediaTimeline(
              showInitialLoading: state is TimelineStateLoading,
              showLoadingOlder: state is TimelineStateLoadingOlder,
              onRefresh: () => cubit.load(clearPrevious: true),
              beginSlivers: const [HomeTopSliverPadding()],
              endSlivers: const [HomeBottomSliverPadding()],
            ),
          ),
        ),
      ),
    );
  }
}
