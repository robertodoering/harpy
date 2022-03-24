import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class Timeline extends ConsumerStatefulWidget {
  const Timeline({
    required this.provider,
    this.tweetBuilder = TweetList.defaultTweetBuilder,
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
    this.refreshIndicatorOffset,
    this.scrollToTopOffset,
    this.onChangeFilter,
    this.onUpdatedTweetVisibility,
    this.scrollPosition = 0,
  });

  final StateNotifierProviderOverrideMixin<TimelineNotifier, TimelineState>
      provider;
  final TweetBuilder tweetBuilder;
  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;
  final double? refreshIndicatorOffset;
  final double? scrollToTopOffset;

  /// A callback used to open the filter selection for the
  /// [TimelineState.noData] state.
  final VoidCallback? onChangeFilter;

  final ValueChanged<TweetData>? onUpdatedTweetVisibility;

  /// Determines which scroll position the [ScrollToTop] and [LoadMoreHandler]
  /// should listen to.
  ///
  /// Used when a [PrimaryScrollController] is available and has multiple active
  /// scroll positions (e.g. in the [NestedScrollView] of the [HomePage]).
  final int scrollPosition;

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends ConsumerState<Timeline>
    with AutomaticKeepAliveClientMixin {
  ScrollController? _controller;
  bool _disposeController = false;

  /// The index of the newest visible tweet.
  int _newestVisibleIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controller == null) {
      _controller = PrimaryScrollController.of(context) ?? ScrollController();
      _disposeController = PrimaryScrollController.of(context) == null;
    }
  }

  @override
  void dispose() {
    if (_disposeController) _controller?.dispose();

    super.dispose();
  }

  void _onLayoutFinished({
    required BuiltList<TweetData> tweets,
    required int firstIndex,
    required int lastIndex,
  }) {
    final index = firstIndex ~/ 2;

    if (tweets.isNotEmpty && _newestVisibleIndex != index) {
      final tweet = tweets[index];

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (mounted) setState(() => _newestVisibleIndex = index);

        // wait a second to see whether this tweet is still visible before
        // notifying
        Future<void>.delayed(const Duration(seconds: 1)).then((_) {
          if (mounted && _newestVisibleIndex == index) {
            widget.onUpdatedTweetVisibility?.call(tweet);
          }
        });
      });
    }
  }

  Widget _tweetBuilder(TimelineState state, TweetData tweet) {
    return state.showNewTweetsExist(tweet.originalId)
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NewTweetsText(state.initialResultsCount),
              verticalSpacer,
              widget.tweetBuilder(tweet),
            ],
          )
        : widget.tweetBuilder(tweet);
  }

  void _providerListener(TimelineState? previous, TimelineState next) {
    if (next.scrollToEnd) {
      final mediaQuery = MediaQuery.of(context);
      final position = _controller!.positions.elementAt(widget.scrollPosition);

      // scroll to the end after the list has been built
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _controller!.jumpTo(
          // + extra height to make sure we reach the end
          position.maxScrollExtent + mediaQuery.size.height * 3,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final state = ref.watch(widget.provider);
    final notifier = ref.watch(widget.provider.notifier);

    ref.listen(widget.provider, _providerListener);

    return ScrollToTop(
      controller: _controller,
      scrollPosition: widget.scrollPosition,
      bottomPadding: widget.scrollToTopOffset,
      content: AnimatedNumber(
        duration: kShortAnimationDuration,
        number: _newestVisibleIndex + 1,
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          UserScrollDirection.of(context)?.idle();
          await notifier.load();
        },
        edgeOffset: widget.refreshIndicatorOffset ?? 0,
        child: LoadMoreHandler(
          controller: _controller!,
          scrollPosition: widget.scrollPosition,
          listen: state.canLoadMore,
          onLoadMore: notifier.loadOlder,
          child: TweetList(
            state.tweets.toList(),
            controller: _controller,
            tweetBuilder: (tweet) => _tweetBuilder(state, tweet),
            onLayoutFinished: (firstIndex, lastIndex) => _onLayoutFinished(
              tweets: state.tweets,
              firstIndex: firstIndex,
              lastIndex: lastIndex,
            ),
            beginSlivers: [
              ...widget.beginSlivers,
              ...?state.mapOrNull(
                loading: (_) => const [
                  sliverVerticalSpacer,
                  TweetListLoadingSliver(),
                ],
                error: (_) => [
                  SliverFillLoadingError(
                    message: const Text('error loading tweets'),
                    onRetry: () => notifier.load(clearPrevious: true),
                  ),
                ],
              ),
            ],
            endSlivers: [
              ...?state.mapOrNull(
                data: (data) => [
                  if (!data.canLoadMore) ...[
                    const SliverFillInfoMessage(
                      secondaryMessage: Text('no more tweets available'),
                    ),
                  ],
                ],
                noData: (_) => [
                  SliverFillLoadingError(
                    message: const Text('no tweets found'),
                    onChangeFilter:
                        notifier.filter != null ? widget.onChangeFilter : null,
                  ),
                ],
                loadingMore: (_) => [
                  const SliverLoadingIndicator(),
                  sliverVerticalSpacer,
                ],
              ),
              ...widget.endSlivers,
            ],
          ),
        ),
      ),
    );
  }
}
