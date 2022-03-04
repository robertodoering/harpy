import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class MediaTimelineMedia extends ConsumerWidget {
  const MediaTimelineMedia({
    required this.entry,
  });

  final MediaTimelineEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    Widget child;

    switch (entry.media.type) {
      case MediaType.image:
        child = HarpyImage(
          imageUrl: entry.media.appropriateUrl(mediaPreferences, connectivity),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
        break;
      case MediaType.gif:
        child = VisibilityChangeListener(
          detectorKey: ObjectKey(entry),
          child: TweetGif(
            tweet: entry.tweet,
            compact: true,
          ),
        );
        break;
      case MediaType.video:
        child = VisibilityChangeListener(
          detectorKey: ObjectKey(entry),
          child: TweetVideo(
            tweet: entry.tweet,
            compact: true,
            overlayBuilder: (data, notifier, child) => SmallVideoPlayerOverlay(
              data: data,
              notifier: notifier,
              child: child,
            ),
          ),
        );
        break;
    }

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: harpyTheme.borderRadius,
      child: AspectRatio(
        aspectRatio: entry.media.aspectRatioDouble,
        child: child,
      ),
    );
  }
}
