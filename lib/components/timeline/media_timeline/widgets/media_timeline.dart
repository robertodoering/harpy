import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class MediaTimeline extends ConsumerStatefulWidget {
  const MediaTimeline({
    required this.provider,
    this.scrollToTopOffset,
    this.beginSlivers = const [],
    this.endSlivers = const [SliverBottomPadding()],
  });

  final AutoDisposeStateNotifierProvider<TimelineNotifier, TimelineState>
      provider;

  final double? scrollToTopOffset;
  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;

  @override
  ConsumerState<MediaTimeline> createState() => _MediaTimelineState();
}

class _MediaTimelineState extends ConsumerState<MediaTimeline> {
  ScrollController? _controller;
  bool _disposeController = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeTimelineProvider.notifier).loadInitial();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controller == null) {
      _controller =
          PrimaryScrollController.maybeOf(context) ?? ScrollController();
      _disposeController = PrimaryScrollController.maybeOf(context) == null;
    }
  }

  @override
  void dispose() {
    if (_disposeController) _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timelineState = ref.watch(widget.provider);
    final timelineNotifier = ref.watch(widget.provider.notifier);
    final mediaEntries = ref.watch(mediaTimelineProvider(timelineState.tweets));

    return ScrollToTop(
      controller: _controller,
      bottomPadding: widget.scrollToTopOffset,
      child: LoadMoreHandler(
        controller: _controller!,
        listen: timelineState.canLoadMore,
        onLoadMore: timelineNotifier.loadOlder,
        child: CustomScrollView(
          key: const PageStorageKey('media_timeline'),
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
                padding: theme.spacing.edgeInsets,
                sliver: MediaTimelineMediaList(entries: mediaEntries),
              ),
            ],
            ...?timelineState.mapOrNull(
              data: (_) => [
                if (mediaEntries.isEmpty)
                  const SliverFillInfoMessage(
                    secondaryMessage: Text('no media'),
                  ),
              ],
              loading: (_) => [const SliverFillLoadingIndicator()],
              loadingMore: (state) => [
                if (mediaEntries.isEmpty)
                  const SliverFillLoadingIndicator()
                else
                  const SliverLoadingIndicator(),
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
    final theme = Theme.of(context);
    final layout = ref.watch(layoutPreferencesProvider);
    final layoutNotifier = ref.watch(layoutPreferencesProvider.notifier);

    return SliverToBoxAdapter(
      child: Padding(
        padding: theme.spacing.edgeInsets.copyWith(bottom: 0),
        child: Row(
          children: [
            RbyButton.card(
              icon: const Icon(CupertinoIcons.refresh),
              onTap: onRefresh,
            ),
            const Spacer(),
            RbyButton.card(
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
