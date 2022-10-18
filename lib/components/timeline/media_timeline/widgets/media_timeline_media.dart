import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

/// Builds the image, gif or video that is used in the [MediaTimeline].
class MediaTimelineMedia extends ConsumerWidget {
  const MediaTimelineMedia({
    required this.entry,
    required this.delegates,
    required this.onTap,
  });

  final MediaTimelineEntry entry;
  final TweetDelegates delegates;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final layout = ref.watch(layoutPreferencesProvider);
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    Widget child;

    final heroTag = 'media${mediaHeroTag(
      context,
      tweet: entry.tweet,
      media: entry.media,
    )}';

    void onMediaLongPress() => showMediaActionsBottomSheet(
          ref,
          media: entry.media,
          delegates: delegates,
        );

    switch (entry.media.type) {
      case MediaType.image:
        child = GestureDetector(
          onTap: onTap,
          onLongPress: onMediaLongPress,
          child: Hero(
            tag: heroTag,
            placeholderBuilder: (_, __, child) => child,
            child: HarpyImage(
              imageUrl: entry.media.appropriateUrl(
                mediaPreferences,
                connectivity,
              ),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        );
        break;
      case MediaType.gif:
        child = VisibilityChangeListener(
          detectorKey: ObjectKey(entry),
          child: TweetGif(
            tweet: entry.tweet,
            heroTag: heroTag,
            placeholderBuilder: (_, __, child) => child,
            compact: true,
            onGifTap: onTap,
            onGifLongPress: onMediaLongPress,
          ),
        );
        break;
      case MediaType.video:
        child = VisibilityChangeListener(
          detectorKey: ObjectKey(entry),
          child: TweetVideo(
            tweet: entry.tweet,
            heroTag: heroTag,
            placeholderBuilder: (_, __, child) => child,
            compact: true,
            onVideoLongPress: onMediaLongPress,
            overlayBuilder: (data, notifier, child) => layout.mediaTiled
                ? SmallVideoPlayerOverlay(
                    tweet: entry.tweet,
                    data: data,
                    notifier: notifier,
                    onVideoTap: onTap,
                    onVideoLongPress: onMediaLongPress,
                    child: child,
                  )
                : StaticVideoPlayerOverlay(
                    tweet: entry.tweet,
                    notifier: notifier,
                    data: data,
                    onVideoTap: onTap,
                    onVideoLongPress: onMediaLongPress,
                    child: child,
                  ),
          ),
        );
        break;
    }

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: theme.shape.borderRadius,
      child: SensitiveMediaOverlay(
        tweet: entry.tweet,
        child: AspectRatio(
          aspectRatio: entry.media.aspectRatioDouble,
          child: child,
        ),
      ),
    );
  }
}
