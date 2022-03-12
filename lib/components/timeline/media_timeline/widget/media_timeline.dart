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
  });

  final StateNotifierProviderOverrideMixin<TimelineNotifier, TimelineState>
      provider;

  final List<Widget> beginSlivers;
  final List<Widget> endSlivers;

  @override
  _MediaTimelineState createState() => _MediaTimelineState();
}

class _MediaTimelineState extends ConsumerState<MediaTimeline>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();

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
      child: LoadMoreHandler(
        controller: _controller,
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
