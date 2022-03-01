import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/tweet/widgets/media/overlays/gif_video_player_overlay.dart';
import 'package:harpy/core/core.dart';
import 'package:video_player/video_player.dart';

class TweetGif extends ConsumerWidget {
  const TweetGif({
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
        'best': tweet.media.single.bestUrl,
      }),
      autoplay: mediaPreferences.shouldAutoplayMedia(connectivity),
      loop: true,
    );

    final state = ref.watch(videoPlayerProvider(arguments));
    final notifier = ref.watch(videoPlayerProvider(arguments).notifier);

    return state.maybeMap(
      data: (value) => GifVideoPlayerOverlay(
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
        center: const MediaThumbnailIcon(icon: Icon(Icons.gif)),
        onTap: notifier.initialize,
      ),
    );
  }
}
