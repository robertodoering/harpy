import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:video_player/video_player.dart';

class TweetVideo extends ConsumerWidget {
  const TweetVideo({
    required this.tweet,
  });

  final TweetData tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    final videoMediaData = tweet.media.single as VideoMediaData;

    final arguments = VideoPlayerArguments(
      urls: BuiltMap.from(<String, String>{
        for (var i = 0; i < min(3, videoMediaData.variants.length); i++)
          _qualityNames[i]: videoMediaData.variants[i].url!,
      }),
      loop: false,
    );

    final state = ref.watch(videoPlayerProvider(arguments));
    final notifier = ref.watch(videoPlayerProvider(arguments).notifier);

    // TODO: wrap static video player overlay with route aware widget to pause
    //  videos on navigation.
    return MediaAutoplay(
      state: state,
      notifier: notifier,
      enableAutoplay: mediaPreferences.shouldAutoplayVideos(connectivity),
      child: state.maybeMap(
        data: (value) => StaticVideoPlayerOverlay(
          notifier: notifier,
          data: value,
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
          center: const MediaThumbnailIcon(icon: CircularProgressIndicator()),
        ),
        orElse: () => MediaThumbnail(
          thumbnail: videoMediaData.thumbnail,
          center: const MediaThumbnailIcon(
            icon: Icon(Icons.play_arrow_rounded),
          ),
          onTap: notifier.initialize,
        ),
      ),
    );
  }
}

final _qualityNames = ['best', 'normal', 'small'];
