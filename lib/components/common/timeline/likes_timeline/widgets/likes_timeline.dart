import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';

class LikesTimeline extends StatelessWidget {
  const LikesTimeline();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bloc = context.watch<LikesTimelineBloc>();
    final state = bloc.state;

    return ScrollToStart(
      child: LoadMoreListener(
        listen: state.enableRequestOlder,
        onLoadMore: () async {
          bloc.add(const RequestOlderLikesTimeline());
          await bloc.requestOlderCompleter.future;
        },
        child: TweetList(
          state.timelineTweets,
          key: const PageStorageKey<String>('likes_timeline'),
          enableScroll: state.enableScroll,
          endSlivers: [
            if (state.showInitialLoading)
              const TweetListLoadingSliver()
            else if (state.showNoTweetsFound)
              SliverFillLoadingError(
                message: const Text('no liked tweets found'),
                onRetry: () => bloc.add(const RequestLikesTimeline()),
              )
            else if (state.showTimelineError)
              SliverFillLoadingError(
                message: const Text('error loading liked tweets'),
                onRetry: () => bloc.add(const RequestLikesTimeline()),
              )
            else if (state.showLoadingOlder)
              const SliverBoxLoadingIndicator()
            else if (state.showReachedEnd)
              const SliverBoxInfoMessage(
                secondaryMessage: Text('no more liked tweets available'),
              ),
            SliverToBoxAdapter(
              child: SizedBox(height: mediaQuery.padding.bottom),
            ),
          ],
        ),
      ),
    );
  }
}
