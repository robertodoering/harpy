import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

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
  final AutoScrollController _controller = AutoScrollController();

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
                sliver: _MediaList(
                  entries: mediaEntries,
                  controller: _controller,
                ),
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

class _MediaList extends ConsumerWidget {
  const _MediaList({
    required this.entries,
    required this.controller,
  });

  final BuiltList<MediaTimelineEntry> entries;
  final AutoScrollController controller;

  Widget _itemBuilder(BuildContext context, Reader read, int index) {
    return AutoScrollTag(
      key: ValueKey(entries[index]),
      controller: controller,
      index: index,
      child: MediaTimelineMedia(
        entry: entries[index],
        onTap: () => Navigator.of(context).push<void>(
          HeroDialogRoute(
            builder: (_) => MediaGallery(
              initialIndex: index,
              itemCount: entries.length,
              onPageChanged: (index) => controller.scrollToIndex(
                index,
                duration: kShortAnimationDuration,
                preferPosition: AutoScrollPosition.middle,
              ),
              builder: (index) {
                final provider = tweetProvider(entries[index].tweet);

                final tweet = read(provider);
                final tweetNotifier = read(provider.notifier);

                return MediaGalleryEntry(
                  provider: provider,
                  delegates: defaultTweetDelegates(tweet, tweetNotifier),
                  media: entries[index].media,
                  builder: (_) {
                    final heroTag =
                        'media${mediaHeroTag(context, entries[index].media)}';

                    switch (entries[index].media.type) {
                      case MediaType.image:
                        return TweetGalleryImage(
                          media: entries[index].media,
                          heroTag: heroTag,
                          borderRadius: read(harpyThemeProvider).borderRadius,
                        );
                      case MediaType.gif:
                        return TweetGalleryGif(tweet: tweet, heroTag: heroTag);
                      case MediaType.video:
                        return TweetGalleryVideo(
                          tweet: tweet,
                          heroTag: heroTag,
                        );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
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
        (context, index) => _itemBuilder(context, ref.read, index),
        childCount: entries.length,
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
