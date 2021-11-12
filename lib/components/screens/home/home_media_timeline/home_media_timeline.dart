import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class HomeMediaTimeline extends StatelessWidget {
  const HomeMediaTimeline();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<HomeTimelineBloc>();
    final state = bloc.state;

    return ChangeNotifierProvider<MediaTimelineModel>(
      create: (_) => MediaTimelineModel(
        initialTweets: bloc.state.tweets.toList(),
      ),
      child: BlocListener<HomeTimelineBloc, HomeTimelineState>(
        listener: (context, state) {
          context.read<MediaTimelineModel>().updateEntries(
                state.tweets.toList(),
              );
        },
        child: ScrollToStart(
          child: LoadMoreListener(
            listen: state.canRequestOlder,
            onLoadMore: () async {
              bloc.add(const HomeTimelineEvent.loadOlder());
              await bloc.requestOlderCompleter.future;
            },
            child: MediaTimeline(
              showInitialLoading: state.isLoading,
              showLoadingOlder: state.isLoadingOlder,
              beginSlivers: const [
                HomeTopSliverPadding(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
