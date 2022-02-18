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

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends ConsumerState<Timeline>
    with AutomaticKeepAliveClientMixin {
  ScrollController? _controller;
  late bool _disposeController;

  /// The index of the newest visible tweet.
  int _newestVisibleIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controller == null) {
      final primaryScrollController = PrimaryScrollController.of(context);
      _disposeController = primaryScrollController == null;
      _controller ??= primaryScrollController ?? ScrollController();
    }
  }

  @override
  void dispose() {
    if (_disposeController) _controller?.dispose();

    super.dispose();
  }

  void _onLayoutFinished(int firstIndex, int lastIndex) {
    final index = firstIndex ~/ 2;

    if (_newestVisibleIndex != index) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (mounted) setState(() => _newestVisibleIndex = index);
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
    final mediaQuery = MediaQuery.of(context);

    if (next.scrollToEnd) {
      // scroll to the end after the list has been built
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _controller?.jumpTo(
          // + height to make sure we reach the end
          // using `positions` in case the controller is attached to multiple
          //   positions
          _controller?.positions.first.maxScrollExtent ??
              0 + mediaQuery.size.height * 3,
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

    // TODO: refresh indicator

    return ScrollToTop(
      controller: _controller,
      bottomPadding: widget.scrollToTopOffset,
      content: AnimatedNumber(
        duration: kShortAnimationDuration,
        number: _newestVisibleIndex + 1,
      ),
      child: LoadMoreHandler(
        controller: _controller!,
        listen: state.canLoadMore,
        onLoadMore: notifier.loadOlder,
        child: TweetList(
          state.tweets.toList(),
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
                  onRetry: () => notifier.load(clearPrevious: true),
                ),
              ],
            ),
          ],
          endSlivers: [
            ...?state.mapOrNull(
              data: (data) => [
                if (!data.canLoadMore) ...[
                  const SliverInfoMessage(
                    secondaryMessage: Text('no more tweets available'),
                  ),
                  sliverVerticalSpacer,
                ],
              ],
              noData: (_) => [
                SliverFillLoadingError(
                  message: const Text('no tweets found'),
                  onChangeFilter:
                      notifier.filter != null ? widget.onChangeFilter : null,
                ),
                sliverVerticalSpacer,
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
    );
  }
}
