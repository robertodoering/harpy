import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/list/load_more_listener.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/list/scroll_to_start.dart';
import 'package:harpy/components/common/list/slivers/sliver_box_info_message.dart';
import 'package:harpy/components/common/list/slivers/sliver_box_loading_indicator.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_error.dart';
import 'package:harpy/components/common/list/slivers/sliver_fill_loading_indicator.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/timeline/new/home_timeline/bloc/home_timeline_bloc.dart';
import 'package:harpy/components/tweet/widgets/tweet_list.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

import 'content/home_app_bar.dart';
import 'content/new_tweets_text.dart';

class HomeTimeline extends StatefulWidget {
  const HomeTimeline();

  @override
  _HomeTimelineState createState() => _HomeTimelineState();
}

class _HomeTimelineState extends State<HomeTimeline> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  void _blocListener(BuildContext context, HomeTimelineState state) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    if (state is HomeTimelineResult &&
        state.initialResults &&
        state.includesLastVisibleTweet &&
        state.newTweetsExist) {
      // scroll to the end after the list has been built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.jumpTo(
          // + height to make sure we reach the end
          _controller.position.maxScrollExtent + mediaQuery.size.height / 2,
        );
      });
    }
  }

  Widget _tweetBuilder(
    HomeTimelineState state,
    TweetData tweet,
  ) {
    bool newTweetsExist = false;
    bool isLastInitialTweet = false;
    bool includesLastVisibleTweet = false;

    if (state is HomeTimelineResult) {
      newTweetsExist = state.newTweetsExist;
      isLastInitialTweet = state.lastInitialTweet == tweet.idStr;
      includesLastVisibleTweet = state.includesLastVisibleTweet;
    } else if (state is HomeTimelineLoadingOlder) {
      newTweetsExist = state.oldResult.newTweetsExist;
      isLastInitialTweet = state.oldResult.lastInitialTweet == tweet.idStr;
      includesLastVisibleTweet = state.oldResult.includesLastVisibleTweet;
    }

    if (includesLastVisibleTweet && newTweetsExist && isLastInitialTweet) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const NewTweetsText(),
          defaultVerticalSpacer,
          TweetList.defaultTweetBuilder(tweet),
        ],
      );
    } else {
      return TweetList.defaultTweetBuilder(tweet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final NewHomeTimelineBloc bloc = context.watch<NewHomeTimelineBloc>();
    final HomeTimelineState state = bloc.state;

    return BlocListener<NewHomeTimelineBloc, HomeTimelineState>(
      listener: _blocListener,
      child: ScrollDirectionListener(
        child: ScrollToStart(
          controller: _controller,
          child: RefreshIndicator(
            onRefresh: () async {
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
                controller: _controller,
                tweetBuilder: (TweetData tweet) => _tweetBuilder(state, tweet),
                enableScroll: state.enableScroll,
                beginSlivers: const <Widget>[
                  HomeAppBar(),
                ],
                endSlivers: <Widget>[
                  if (state.showInitialLoading)
                    const SliverFillLoadingIndicator()
                  else if (state.showNoTweetsFound)
                    SliverFillLoadingError(
                      message: const Text('no tweets found'),
                      onRetry: () => bloc.add(
                        const RefreshHomeTimeline(clearPrevious: true),
                      ),
                    )
                  else if (state.showSearchError)
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
