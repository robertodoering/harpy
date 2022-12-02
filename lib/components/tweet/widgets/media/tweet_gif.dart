import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';
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
    this.placeholderBuilder,
    this.compact = false,
    this.onGifTap,
    this.onGifLongPress,
  });

  final LegacyTweetData tweet;
  final Object heroTag;
  final HeroPlaceholderBuilder? placeholderBuilder;
  final bool compact;
  final VoidCallback? onGifTap;
  final VoidCallback? onGifLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    final mediaData = tweet.media.single as VideoMediaData;
    final arguments = _videoArguments(mediaData);

    final state = ref.watch(videoPlayerProvider(arguments));
    final notifier = ref.watch(videoPlayerProvider(arguments).notifier);

    return VisibilityChangeListener(
      detectorKey: ObjectKey(heroTag),
      child: MediaAutoplay(
        state: state,
        notifier: notifier,
        enableAutoplay: mediaPreferences.shouldAutoplayGifs(connectivity),
        child: Hero(
          tag: heroTag,
          placeholderBuilder: placeholderBuilder,
          flightShuttleBuilder: (
            _,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) =>
              borderRadiusFlightShuttleBuilder(
            theme.shape.borderRadius,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ),
          child: AspectRatio(
            aspectRatio: mediaData.aspectRatioDouble,
            child: state.maybeMap(
              data: (value) => GifVideoPlayerOverlay(
                notifier: notifier,
                data: value,
                compact: compact,
                onGifTap: onGifTap,
                onGifLongPress: onGifLongPress,
                child: OverflowBox(
                  maxHeight: double.infinity,
                  child: AspectRatio(
                    aspectRatio: mediaData.aspectRatioDouble,
                    child: VideoPlayer(notifier.controller),
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
                onLongPress: onGifLongPress,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
