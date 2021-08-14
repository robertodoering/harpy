import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

// todo: move `ScrollToStart` widget to the `TweetList` and enable unread
//   counter for every tweet list

class HomeTimeline extends StatefulWidget {
  const HomeTimeline();

  @override
  _HomeTimelineState createState() => _HomeTimelineState();
}

class _HomeTimelineState extends State<HomeTimeline> {
  late ScrollController _controller;

  /// The index of the newest visible tweet.
  int _newestVisibleIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller = PrimaryScrollController.of(context)!;
  }

  void _onLayoutFinished(int firstIndex, int lastIndex) {
    final index = firstIndex ~/ 2;

    if (_newestVisibleIndex != index) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() => _newestVisibleIndex = index);
      });
    }
  }

  void _blocListener(BuildContext context, HomeTimelineState state) {
    final mediaQuery = MediaQuery.of(context);

    if (state is HomeTimelineResult &&
        state.initialResults &&
        state.newTweets > 0) {
      // scroll to the end after the list has been built
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _controller.jumpTo(
          // + height to make sure we reach the end
          // using `positions` in case the controller is attached to multiple
          //   positions
          // ignore: invalid_use_of_protected_member
          _controller.positions.first.maxScrollExtent +
              mediaQuery.size.height / 2,
        );
      });
    }
  }

  Widget _tweetBuilder(HomeTimelineState state, TweetData tweet) {
    if (state.showNewTweetsExist(tweet.originalId)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NewTweetsText(state.newTweets),
          defaultVerticalSpacer,
          HomeTimelineTweetCard(tweet),
        ],
      );
    } else {
      return HomeTimelineTweetCard(tweet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bloc = context.watch<HomeTimelineBloc>();
    final state = bloc.state;

    return BlocListener<HomeTimelineBloc, HomeTimelineState>(
      listener: _blocListener,
      child: ScrollToStart(
        controller: _controller,
        text: AnimatedNumber(number: _newestVisibleIndex),
        child: CustomRefreshIndicator(
          onRefresh: () async {
            ScrollDirection.of(context)!.reset();
            bloc.add(const RefreshHomeTimeline());
            await bloc.refreshCompleter.future;
          },
          child: LoadMoreListener(
            listen: state.enableRequestOlder,
            onLoadMore: () async {
              bloc.add(const RequestOlderHomeTimeline());
              await bloc.requestOlderCompleter.future;
            },
            child: TweetList(
              state.timelineTweets,
              key: const PageStorageKey<String>('home_timeline'),
              controller: _controller,
              tweetBuilder: (tweet) => _tweetBuilder(state, tweet),
              onLayoutFinished: _onLayoutFinished,
              enableScroll: state.hasTweets,
              beginSlivers: [
                const HomeTopSliverPadding(),
                if (state.hasTweets) const HomeTimelineTopRow(),
              ],
              endSlivers: [
                if (state.showInitialLoading)
                  const TweetListLoadingSliver()
                else if (state.showNoTweetsFound)
                  SliverFillLoadingError(
                    message: const Text('no tweets found'),
                    onRetry: () => bloc.add(
                      const RefreshHomeTimeline(clearPrevious: true),
                    ),
                    onClearFilter: state.hasTimelineFilter
                        ? () => bloc.add(const FilterHomeTimeline(
                              timelineFilter: TimelineFilter.empty,
                            ))
                        : null,
                  )
                else if (state.showTimelineError)
                  SliverFillLoadingError(
                    message: const Text('error loading tweets'),
                    onRetry: () => bloc.add(
                      const RefreshHomeTimeline(clearPrevious: true),
                    ),
                  )
                else if (state.showLoadingOlder)
                  const SliverBoxLoadingIndicator()
                else if (state.showReachedEnd)
                  const SliverBoxInfoMessage(
                    secondaryMessage: Text('no more tweets available'),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(height: mediaQuery.padding.bottom),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
