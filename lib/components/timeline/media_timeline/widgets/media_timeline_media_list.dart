import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

/// Builds a [SliverWaterfallFlow] for the media of the [MediaTimeline].
class MediaTimelineMediaList extends ConsumerWidget {
  const MediaTimelineMediaList({
    required this.entries,
  });

  final BuiltList<MediaTimelineEntry> entries;

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
        (context, index) => _MediaEntryItem(
          entries: entries,
          index: index,
        ),
        childCount: entries.length,
      ),
    );
  }
}

class _MediaEntryItem extends ConsumerStatefulWidget {
  const _MediaEntryItem({
    required this.entries,
    required this.index,
  });

  final BuiltList<MediaTimelineEntry> entries;
  final int index;

  @override
  _MediaEntryItemState createState() => _MediaEntryItemState();
}

class _MediaEntryItemState extends ConsumerState<_MediaEntryItem> {
  @override
  void initState() {
    super.initState();

    final entry = widget.entries[widget.index];

    final provider = tweetProvider(
      entry.tweet.originalId,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(provider.notifier).initialize(entry.tweet);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entries[widget.index];
    final provider = tweetProvider(entry.tweet.originalId);

    var tweet = ref.read(provider);
    var tweetNotifier = ref.read(provider.notifier);

    if (tweet == null) return const SizedBox();

    var delegates = defaultTweetDelegates(tweet, tweetNotifier);

    return MediaTimelineMedia(
      entry: entry,
      delegates: delegates,
      onTap: () => Navigator.of(context).push<void>(
        HeroDialogRoute(
          builder: (_) => MediaGallery(
            initialIndex: widget.index,
            itemCount: widget.entries.length,
            actions: _mediaTimelineOverlayActions,
            builder: (index) {
              final provider = tweetProvider(
                widget.entries[index].tweet.originalId,
              );
              tweet = ref.read(provider);

              // We need to initialize the tweet in case it's not yet
              // initialized. This can happen if the user scroll the gallery and
              // reaches uninitialized tweets.
              SchedulerBinding.instance.addPostFrameCallback((_) {
                tweetNotifier = ref.read(provider.notifier)
                  ..initialize(widget.entries[index].tweet);
              });

              delegates = defaultTweetDelegates(
                tweet ?? widget.entries[index].tweet,
                tweetNotifier,
              );

              if (tweet == null) return null;

              return MediaGalleryEntry(
                tweet: tweet!,
                delegates: delegates,
                media: widget.entries[index].media,
                builder: (_) {
                  final heroTag = 'media${mediaHeroTag(
                    context,
                    tweet: tweet!,
                    media: widget.entries[index].media,
                  )}';

                  switch (widget.entries[index].media.type) {
                    case MediaType.image:
                      return TweetGalleryImage(
                        media: widget.entries[index].media,
                        heroTag: heroTag,
                        borderRadius: ref.read(harpyThemeProvider).borderRadius,
                      );
                    case MediaType.gif:
                      return TweetGif(tweet: tweet!, heroTag: heroTag);
                    case MediaType.video:
                      return TweetGalleryVideo(tweet: tweet!, heroTag: heroTag);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

const _mediaTimelineOverlayActions = {
  MediaOverlayActions.retweet,
  MediaOverlayActions.favorite,
  MediaOverlayActions.spacer,
  MediaOverlayActions.show,
  MediaOverlayActions.actionsButton,
};
