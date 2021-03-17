import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/list/load_more_listener.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
import 'package:harpy/components/common/list/slivers/sliver_box_info_message.dart';
import 'package:harpy/components/common/list/slivers/sliver_box_loading_indicator.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_error.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_indicator.dart';
import 'package:harpy/components/timeline/likes_timeline/bloc/likes_timeline_bloc.dart';
import 'package:harpy/components/tweet/widgets/tweet_list.dart';

class LikesTimeline extends StatelessWidget {
  const LikesTimeline();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final LikesTimelineBloc bloc = context.watch<LikesTimelineBloc>();
    final LikesTimelineState state = bloc.state;

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
          endSlivers: <Widget>[
            if (state.showInitialLoading)
              const SliverFillLoadingIndicator()
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
