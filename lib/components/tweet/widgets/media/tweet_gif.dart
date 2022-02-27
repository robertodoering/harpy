import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

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

    final arguments = HarpyVideoPlayerArguments(
      urls: BuiltMap.from(<String, String>{
        'best': tweet.media.single.bestUrl,
      }),
      autoplay: mediaPreferences.shouldAutoplayMedia(connectivity),
      loop: true,
    );

    final state = ref.watch(harpyVideoPlayerProvider(arguments));
    final notifier = ref.watch(harpyVideoPlayerProvider(arguments).notifier);

    return state.maybeMap(
      data: (value) => const SizedBox(),
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
