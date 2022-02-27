import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
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

  /// TODO: handle autoplay with visibility detector
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    final videoMediaData = tweet.media.single as VideoMediaData;

    final arguments = HarpyVideoPlayerArguments(
      urls: BuiltMap.from(<String, String>{
        for (final variant in videoMediaData.variants)
          '${variant.bitrate}': variant.url!,
      }),
      autoplay: mediaPreferences.shouldAutoplayVideos(connectivity),
      loop: false,
    );

    final state = ref.watch(harpyVideoPlayerProvider(arguments));
    final notifier = ref.watch(harpyVideoPlayerProvider(arguments).notifier);

    return state.maybeMap(
      data: (value) => StaticVideoPlayerOverlay(
        notifier: notifier,
        data: value,
        child: VideoPlayer(notifier.controller),
      ),
      loading: (_) => MediaThumbnail(
        thumbnail: videoMediaData.thumbnail,
        center: const MediaThumbnailIcon(icon: CircularProgressIndicator()),
      ),
      orElse: () => MediaThumbnail(
        thumbnail: videoMediaData.thumbnail,
        center: MediaThumbnailIcon(
          icon: Transform.translate(
            offset: const Offset(3, 0),
            child: const Icon(CupertinoIcons.play),
          ),
        ),
        onTap: notifier.initialize,
      ),
    );
  }
}
