import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class MediaTimeline extends ConsumerStatefulWidget {
  const MediaTimeline({
    required this.provider,
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
    this.scrollPosition = 0,
  });

  final StateNotifierProviderOverrideMixin<TimelineNotifier, TimelineState>
      provider;

  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;
  final int scrollPosition;

  @override
  _MediaTimelineState createState() => _MediaTimelineState();
}

class _MediaTimelineState extends ConsumerState<MediaTimeline>
    with AutomaticKeepAliveClientMixin {
  ScrollController? _controller;
  bool _disposeController = false;

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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final display = ref.watch(displayPreferencesProvider);
    final timelineState = ref.watch(widget.provider);
    final timelineNotifier = ref.watch(widget.provider.notifier);
    final mediaEntries = ref.watch(mediaTimelineProvider(timelineState.tweets));

    return ScrollToTop(
      controller: _controller,
      scrollPosition: widget.scrollPosition,
      child: LoadMoreHandler(
        controller: _controller!,
        scrollPosition: widget.scrollPosition,
        listen: timelineState.canLoadMore,
        onLoadMore: timelineNotifier.loadOlder,
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            ...widget.beginSlivers,
            if (mediaEntries.isNotEmpty) ...[
              _TopActions(
                onRefresh: () {
                  HapticFeedback.lightImpact();
                  timelineNotifier.load(clearPrevious: true);
                },
              ),
              SliverPadding(
                padding: display.edgeInsets,
                sliver: MediaTimelineMediaList(entries: mediaEntries),
              ),
            ],
            ...?timelineState.mapOrNull(
              loading: (_) => [const SliverFillLoadingIndicator()],
              loadingMore: (_) => [
                const SliverLoadingIndicator(),
                sliverVerticalSpacer,
              ],
              noData: (_) => [
                const SliverFillInfoMessage(secondaryMessage: Text('no media')),
              ],
            ),
            ...widget.endSlivers,
          ],
        ),
      ),
    );
  }
}

class _TopActions extends ConsumerWidget {
  const _TopActions({
    required this.onRefresh,
  });

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final layout = ref.watch(layoutPreferencesProvider);
    final layoutNotifier = ref.watch(layoutPreferencesProvider.notifier);

    return SliverToBoxAdapter(
      child: Padding(
        padding: display.edgeInsets.copyWith(bottom: 0),
        child: Row(
          children: [
            HarpyButton.card(
              icon: const Icon(CupertinoIcons.refresh),
              onTap: onRefresh,
            ),
            const Spacer(),
            HarpyButton.card(
              icon: layout.mediaTiled
                  ? const Icon(CupertinoIcons.square_split_2x2)
                  : const Icon(CupertinoIcons.square_split_1x2),
              onTap: () {
                HapticFeedback.lightImpact();
                layoutNotifier.setMediaTiled(!layout.mediaTiled);
              },
            ),
          ],
        ),
      ),
    );
  }
}
