import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class MediaTimeline extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final timelineState = ref.watch(provider);
    final timelineNotifier = ref.watch(provider.notifier);
    final mediaEntries = ref.watch(mediaTimelineProvider(timelineState.tweets));

    return CustomScrollView(
      key: const PageStorageKey('media_timeline'),
      slivers: [
        ...beginSlivers,
        if (mediaEntries.isNotEmpty) ...[
          _TopRow(
            onRefresh: () {
              HapticFeedback.lightImpact();
              timelineNotifier.load(clearPrevious: true);
            },
          ),
          SliverPadding(
            padding: display.edgeInsets,
            sliver: _MediaList(entries: mediaEntries),
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
        ...endSlivers,
      ],
    );
  }
}

class _MediaList extends ConsumerWidget {
  const _MediaList({
    required this.entries,
  });

  final BuiltList<MediaTimelineEntry> entries;

  Widget _itemBuilder(BuildContext context, int index) {
    return MediaTimelineMedia(
      entry: entries[index],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);
    final layout = ref.watch(layoutPreferencesProvider);

    return SliverWaterfallFlow(
      gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: layout.mediaTiled ? 2 : 1,
        mainAxisSpacing: display.smallPaddingValue,
        crossAxisSpacing: display.smallPaddingValue,
      ),
      delegate: SliverChildBuilderDelegate(
        _itemBuilder,
        childCount: entries.length,
      ),
    );
  }
}

class _TopRow extends ConsumerWidget {
  const _TopRow({
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
                  ? const Icon(CupertinoIcons.square_split_1x2)
                  : const Icon(CupertinoIcons.square_split_2x2),
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
