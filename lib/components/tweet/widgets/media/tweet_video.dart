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

class TweetVideo extends ConsumerWidget {
  const TweetVideo({
    required this.tweet,
    required this.overlayBuilder,
    this.compact = false,
  });

  final TweetData tweet;
  final OverlayBuilder overlayBuilder;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    final videoMediaData = tweet.media.single as VideoMediaData;

    final arguments = VideoPlayerArguments(
      urls: BuiltMap({
        for (var i = 0; i < min(3, videoMediaData.variants.length); i++)
          _qualityNames[i]: videoMediaData.variants[i].url!,
      }),
      loop: false,
      isVideo: true,
    );

    final state = ref.watch(videoPlayerProvider(arguments));
    final notifier = ref.watch(videoPlayerProvider(arguments).notifier);

    return MediaAutoplay(
      state: state,
      notifier: notifier,
      enableAutoplay: mediaPreferences.shouldAutoplayVideos(connectivity),
      child: state.maybeMap(
        data: (value) => VideoAutopause(
          child: overlayBuilder(
            value,
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
