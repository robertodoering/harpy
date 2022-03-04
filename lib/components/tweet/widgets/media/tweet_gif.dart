import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:video_player/video_player.dart';

class TweetGif extends ConsumerWidget {
  const TweetGif({
    required this.tweet,
    this.compact = false,
  });

  final TweetData tweet;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    final videoMediaData = tweet.media.single as VideoMediaData;

    final arguments = VideoPlayerArguments(
      urls: BuiltMap({'best': videoMediaData.bestUrl}),
      loop: true,
    );

    final state = ref.watch(videoPlayerProvider(arguments));
    final notifier = ref.watch(videoPlayerProvider(arguments).notifier);

    return MediaAutoplay(
      state: state,
      notifier: notifier,
      enableAutoplay: mediaPreferences.shouldAutoplayGifs(connectivity),
      child: state.maybeMap(
        data: (value) => GifVideoPlayerOverlay(
          notifier: notifier,
          data: value,
          compact: compact,
          child: OverflowBox(
            maxHeight: double.infinity,
            child: AspectRatio(
              aspectRatio: videoMediaData.aspectRatioDouble,
              child: VideoPlayer(notifier.controller),
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
            icon: const Icon(Icons.gif),
            compact: compact,
          ),
          onTap: () => notifier.initialize(volume: 0),
        ),
      ),
    );
  }
}
