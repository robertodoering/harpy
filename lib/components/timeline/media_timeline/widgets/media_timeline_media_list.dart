import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
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

  Widget _itemBuilder(BuildContext context, Reader read, int index) {
    final provider = tweetProvider(entries[index].tweet);

    var tweet = read(provider);
    var tweetNotifier = read(provider.notifier);

    var delegates = defaultTweetDelegates(tweet, tweetNotifier);

    return MediaTimelineMedia(
      entry: entries[index],
      delegates: delegates,
      onTap: () => Navigator.of(context).push<void>(
        HeroDialogRoute(
          builder: (_) => MediaGallery(
            initialIndex: index,
            itemCount: entries.length,
            actions: _mediaTimelineOverlayActions,
            builder: (index) {
              final provider = tweetProvider(entries[index].tweet);

              tweet = read(provider);
              tweetNotifier = read(provider.notifier);
              delegates = defaultTweetDelegates(tweet, tweetNotifier);

              return MediaGalleryEntry(
                provider: provider,
                delegates: delegates,
                media: entries[index].media,
                builder: (_) {
                  final heroTag = 'media${mediaHeroTag(
                    context,
                    tweet: entries[index].tweet,
                    media: entries[index].media,
                  )}';

                  switch (entries[index].media.type) {
                    case MediaType.image:
                      return TweetGalleryImage(
                        media: entries[index].media,
                        heroTag: heroTag,
                        borderRadius: read(harpyThemeProvider).borderRadius,
                      );
                    case MediaType.gif:
                      return TweetGif(tweet: tweet, heroTag: heroTag);
                    case MediaType.video:
                      return TweetGalleryVideo(tweet: tweet, heroTag: heroTag);
                  }
                },
              );
            },
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

const _mediaTimelineOverlayActions = {
  MediaOverlayActions.retweet,
  MediaOverlayActions.favorite,
  MediaOverlayActions.spacer,
  MediaOverlayActions.show,
  MediaOverlayActions.actionsButton,
};
