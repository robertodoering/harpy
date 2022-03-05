import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:video_player/video_player.dart';

const _qualityNames = ['best', 'normal', 'small'];

typedef OverlayBuilder = Widget Function(
  VideoPlayerStateData data,
  VideoPlayerNotifier notifier,
  Widget child,
);

VideoPlayerArguments _videoArguments(VideoMediaData mediaData) {
  return VideoPlayerArguments(
    urls: BuiltMap({
      for (var i = 0; i < min(3, mediaData.variants.length); i++)
        _qualityNames[i]: mediaData.variants[i].url!,
    }),
    loop: false,
    isVideo: true,
  );
}

class TweetVideo extends ConsumerWidget {
  const TweetVideo({
    required this.tweet,
    required this.overlayBuilder,
    required this.heroTag,
    this.compact = false,
  });

  final TweetData tweet;
  final OverlayBuilder overlayBuilder;
  final Object heroTag;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    final videoMediaData = tweet.media.single as VideoMediaData;

    final arguments = _videoArguments(videoMediaData);

    final provider = videoPlayerProvider(arguments);
    final state = ref.watch(provider);
    final notifier = ref.watch(provider.notifier);

    return MediaAutoplay(
      state: state,
      notifier: notifier,
      enableAutoplay: mediaPreferences.shouldAutoplayVideos(connectivity),
      child: state.maybeMap(
        data: (data) => VideoAutopause(
          child: Hero(
            tag: heroTag,
            child: overlayBuilder(
              data,
              notifier,
              OverflowBox(
                maxHeight: double.infinity,
                child: AspectRatio(
                  aspectRatio: videoMediaData.aspectRatioDouble,
                  child: VideoPlayer(notifier.controller),
                ),
              ),
            ),
          ),
        ),
        loading: (_) => MediaThumbnail(
          thumbnail: videoMediaData.thumbnail,
          center: MediaThumbnailIcon(
            icon: const CircularProgressIndicator(),
            compact: compact,
          ),
        ),
        orElse: () => MediaThumbnail(
          thumbnail: videoMediaData.thumbnail,
          center: MediaThumbnailIcon(
            icon: const Icon(Icons.play_arrow_rounded),
            compact: compact,
          ),
          onTap: notifier.initialize,
        ),
      ),
    );
  }
}

class TweetGalleryVideo extends ConsumerWidget {
  const TweetGalleryVideo({required this.tweet, required this.heroTag});

  final TweetData tweet;
  final Object heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);
    final videoMediaData = tweet.media.single as VideoMediaData;

    final arguments = _videoArguments(videoMediaData);

    final state = ref.watch(videoPlayerProvider(arguments));
    final notifier = ref.watch(videoPlayerProvider(arguments).notifier);

    return state.maybeMap(
      data: (data) => VideoAutopause(
        child: Hero(
          tag: heroTag,
          flightShuttleBuilder:
              (_, animation, flightDirection, fromHeroContext, toHeroContext) =>
                  _flightShuttleBuilder(
            harpyTheme.borderRadius,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ),
          child: AspectRatio(
            aspectRatio: videoMediaData.aspectRatioDouble,
            child: StaticVideoPlayerOverlay(
              data: data,
              notifier: notifier,
              child: VideoPlayer(notifier.controller),
            ),
          ),
        ),
      ),
      loading: (_) => MediaThumbnail(
        thumbnail: videoMediaData.thumbnail,
        center: const MediaThumbnailIcon(
          icon: CircularProgressIndicator(),
        ),
      ),
      orElse: () => MediaThumbnail(
        thumbnail: videoMediaData.thumbnail,
        center: const MediaThumbnailIcon(
          icon: Icon(Icons.play_arrow_rounded),
        ),
        onTap: notifier.initialize,
      ),
    );
  }
}

Widget _flightShuttleBuilder(
  BorderRadius beginRadius,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final hero = flightDirection == HeroFlightDirection.push
      ? fromHeroContext.widget as Hero
      : toHeroContext.widget as Hero;

  final tween = BorderRadiusTween(
    begin: beginRadius,
    end: BorderRadius.zero,
  );

  return AnimatedBuilder(
    animation: animation,
    builder: (_, __) => ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: tween.evaluate(animation),
      child: hero.child,
    ),
  );
}
