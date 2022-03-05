import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:video_player/video_player.dart';

VideoPlayerArguments _videoArguments(VideoMediaData mediaData) {
  return VideoPlayerArguments(
    urls: BuiltMap({'best': mediaData.bestUrl}),
    loop: true,
  );
}

class TweetGif extends ConsumerWidget {
  const TweetGif({
    required this.tweet,
    required this.heroTag,
    this.compact = false,
    this.onGifTap,
  });

  final TweetData tweet;
  final Object heroTag;
  final bool compact;
  final VoidCallback? onGifTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    final mediaData = tweet.media.single as VideoMediaData;
    final arguments = _videoArguments(mediaData);

    final state = ref.watch(videoPlayerProvider(arguments));
    final notifier = ref.watch(videoPlayerProvider(arguments).notifier);

    return MediaAutoplay(
      state: state,
      notifier: notifier,
      enableAutoplay: mediaPreferences.shouldAutoplayGifs(connectivity),
      child: state.maybeMap(
        data: (value) => Hero(
          tag: heroTag,
          child: GifVideoPlayerOverlay(
            notifier: notifier,
            data: value,
            compact: compact,
            onGifTap: onGifTap,
            child: OverflowBox(
              maxHeight: double.infinity,
              child: AspectRatio(
                aspectRatio: mediaData.aspectRatioDouble,
                child: VideoPlayer(notifier.controller),
              ),
            ),
          ),
        ),
        loading: (_) => MediaThumbnail(
          thumbnail: mediaData.thumbnail,
          center: MediaThumbnailIcon(
            icon: const CircularProgressIndicator(),
            compact: compact,
          ),
        ),
        orElse: () => MediaThumbnail(
          thumbnail: mediaData.thumbnail,
          center: MediaThumbnailIcon(
            icon: const Icon(Icons.gif),
            compact: compact,
          ),
          onTap: () => notifier.initialize(volume: 0),
        ),
      ),
    );
  }
}

class TweetGalleryGif extends ConsumerWidget {
  const TweetGalleryGif({
    required this.tweet,
    required this.heroTag,
  });

  final TweetData tweet;
  final Object heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    final mediaData = tweet.media.single as VideoMediaData;
    final arguments = _videoArguments(mediaData);

    final state = ref.watch(videoPlayerProvider(arguments));
    final notifier = ref.watch(videoPlayerProvider(arguments).notifier);

    return state.maybeMap(
      data: (value) => Hero(
        tag: heroTag,
        flightShuttleBuilder:
            (_, animation, flightDirection, fromHeroContext, toHeroContext) =>
                borderRadiusFlightShuttleBuilder(
          harpyTheme.borderRadius,
          animation,
          flightDirection,
          fromHeroContext,
          toHeroContext,
        ),
        child: AspectRatio(
          aspectRatio: mediaData.aspectRatioDouble,
          child: GifVideoPlayerOverlay(
            notifier: notifier,
            data: value,
            child: VideoPlayer(notifier.controller),
          ),
        ),
      ),
      loading: (_) => MediaThumbnail(
        thumbnail: mediaData.thumbnail,
        center: const MediaThumbnailIcon(icon: CircularProgressIndicator()),
      ),
      orElse: () => MediaThumbnail(
        thumbnail: mediaData.thumbnail,
        center: const MediaThumbnailIcon(icon: Icon(Icons.gif)),
        onTap: () => notifier.initialize(volume: 0),
      ),
    );
  }
}
