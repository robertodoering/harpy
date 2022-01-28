import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds a [TweetList] for a [TimelineCubit].
///
/// For example implementations, see:
/// * [HomeTimeline]
/// * [LikesTimeline]
/// * [ListTimeline]
/// * [UserTimeline]
/// * [MentionsTimeline]
class Timeline extends StatefulWidget {
  const Timeline({
    this.tweetBuilder = TweetList.defaultTweetBuilder,
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
    this.refreshIndicatorOffset,
    this.listKey,
    this.onChangeFilter,
  });

  final TweetBuilder tweetBuilder;
  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;
  final double? refreshIndicatorOffset;
  final Key? listKey;

  /// A callback used to open the filter selection for the
  /// [TimelineState.noData] state.
  final VoidCallback? onChangeFilter;

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  late ScrollController _controller;
  late bool _disposeController;

  /// The index of the newest visible tweet.
  int _newestVisibleIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final primaryScrollController = PrimaryScrollController.of(context);
    _disposeController = primaryScrollController == null;
    _controller = primaryScrollController ?? ScrollController();
  }

  @override
  void dispose() {
    if (_disposeController) {
      _controller.dispose();
    }

    super.dispose();
  }

  void _onLayoutFinished(int firstIndex, int lastIndex) {
    final index = firstIndex ~/ 2;

    if (_newestVisibleIndex != index) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _newestVisibleIndex = index);
        }
      });
    }
  }

  void _blocListener(BuildContext context, TimelineState state) {
    final mediaQuery = MediaQuery.of(context);

    if (state.scrollToEnd) {
      // scroll to the end after the list has been built
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _controller.jumpTo(
          // + height to make sure we reach the end
          // using `positions` in case the controller is attached to multiple
          //   positions
          // ignore: invalid_use_of_protected_member
          _controller.positions.first.maxScrollExtent +
              mediaQuery.size.height * 3,
        );
      });
    }
  }

  Widget _tweetBuilder(TimelineState state, TweetData tweet) {
    if (state.showNewTweetsExist(tweet.originalId)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NewTweetsText(state.initialResultsCount),
          verticalSpacer,
          widget.tweetBuilder(tweet),
        ],
      );
    } else {
      return widget.tweetBuilder(tweet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<TimelineCubit>();
    final state = cubit.state;

    return BlocListener<TimelineCubit, TimelineState>(
      listener: _blocListener,
      child: ScrollToStart(
        controller: _controller,
        text: AnimatedNumber(number: _newestVisibleIndex + 1),
        child: CustomRefreshIndicator(
          offset: widget.refreshIndicatorOffset ?? config.paddingValue,
          onRefresh: () async {
            ScrollDirection.of(context)?.reset();
            await cubit.load();
          },
          child: LoadMoreListener(
            listen: state.canLoadMore,
            onLoadMore: cubit.loadOlder,
            child: TweetList(
              state.tweets.toList(),
              key: widget.listKey,
              controller: _controller,
              tweetBuilder: (tweet) => _tweetBuilder(state, tweet),
              onLayoutFinished: _onLayoutFinished,
              beginSlivers: [
                ...widget.beginSlivers,
                ...?state.mapOrNull(
                  loading: (_) => const [TweetListLoadingSliver()],
                  error: (_) => [
                    SliverFillLoadingError(
                      message: const Text('error loading tweets'),
                      onRetry: () => cubit.load(clearPrevious: true),
                    ),
                  ],
                ),
              ],
              endSlivers: [
                ...?state.mapOrNull(
                  data: (data) => [
                    if (!data.canLoadMore)
                      const SliverBoxInfoMessage(
                        secondaryMessage: Text('no more tweets available'),
                      ),
                  ],
                  noData: (_) => [
                    SliverFillLoadingError(
                      message: const Text('no tweets found'),
                      onChangeFilter:
                          cubit.filter != null ? widget.onChangeFilter : null,
                    )
                  ],
                  loadingMore: (_) => [const SliverBoxLoadingIndicator()],
                ),
                ...widget.endSlivers,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
