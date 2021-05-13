import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class UserMediaTimeline extends StatelessWidget {
  const UserMediaTimeline();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<UserTimelineBloc>();
    final state = bloc.state;

    return ChangeNotifierProvider<MediaTimelineModel>(
      create: (_) => MediaTimelineModel(
        initialTweets: bloc.state.timelineTweets,
      ),
      child: BlocListener<UserTimelineBloc, UserTimelineState>(
        listener: (context, state) {
          context
              .read<MediaTimelineModel>()
              .updateEntries(state.timelineTweets);
        },
        child: ScrollToStart(
          child: LoadMoreListener(
            listen: state.enableRequestOlder,
            onLoadMore: () async {
              bloc.add(const RequestOlderUserTimeline());
              await bloc.requestOlderCompleter.future;
            },
            child: MediaTimeline(
              showInitialLoading: state.showInitialLoading,
              showLoadingOlder: state.showLoadingOlder,
            ),
          ),
        ),
      ),
    );
  }
}
