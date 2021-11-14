import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class UserMediaTimeline extends StatelessWidget {
  const UserMediaTimeline();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<UserTimelineCubit>();
    final state = cubit.state;

    return ChangeNotifierProvider(
      create: (_) => MediaTimelineModel(
        initialTweets: cubit.state.tweets.toList(),
      ),
      child: BlocListener<UserTimelineCubit, TimelineState>(
        listener: (context, state) {
          context
              .read<MediaTimelineModel>()
              .updateEntries(state.tweets.toList());
        },
        child: ScrollToStart(
          child: LoadMoreListener(
            listen: state.canLoadMore,
            onLoadMore: cubit.loadOlder,
            child: MediaTimeline(
              showInitialLoading: state is TimelineStateInitial,
              showLoadingOlder: state is TimelineStateLoading,
              onRefresh: () => cubit.load(clearPrevious: true),
            ),
          ),
        ),
      ),
    );
  }
}
