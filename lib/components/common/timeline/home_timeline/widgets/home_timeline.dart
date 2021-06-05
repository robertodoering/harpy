import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';

class HomeTimeline extends StatefulWidget {
  // non-const to always rebuild when returning to home screen
  // ignore: prefer_const_constructors_in_immutables
  HomeTimeline();

  @override
  _HomeTimelineState createState() => _HomeTimelineState();
}

class _HomeTimelineState extends State<HomeTimeline> {
  ScrollController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller = PrimaryScrollController.of(context);
  }

  void _blocListener(BuildContext context, HomeTimelineState state) {
    final mediaQuery = MediaQuery.of(context);

    if (state is HomeTimelineResult &&
        state.initialResults &&
        state.newTweets > 0) {
      // scroll to the end after the list has been built
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _controller!.jumpTo(
          // + height to make sure we reach the end
          _controller!.position.maxScrollExtent + mediaQuery.size.height / 2,
        );
      });
    }
  }

  Widget _tweetBuilder(HomeTimelineState state, TweetData tweet) {
    if (state.showNewTweetsExist(tweet.originalId)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          NewTweetsText(state.newTweets),
          defaultVerticalSpacer,
          TweetCard(tweet, rememberVisibility: true),
        ],
      );
    } else {
      return TweetCard(tweet, rememberVisibility: true);
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
        child: CustomRefreshIndicator(
          offset: mediaQuery.padding.top - 8,
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
            child: ScrollAwareFloatingActionButton(
              floatingActionButton: FloatingActionButton(
                onPressed: () => app<HarpyNavigator>().pushComposeScreen(),
                child: const Icon(FeatherIcons.feather, size: 28),
              ),
              child: TweetList(
                state.timelineTweets,
                key: const PageStorageKey<String>('home_timeline'),
                controller: _controller,
                tweetBuilder: (tweet) => _tweetBuilder(state, tweet),
                enableScroll: state.enableScroll,
                endSlivers: <Widget>[
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
      ),
    );
  }
}
