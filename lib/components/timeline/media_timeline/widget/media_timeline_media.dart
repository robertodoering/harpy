import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

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

    // TODO: media widget for gifs & videos

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
        child = Container(
          color: Colors.red,
          alignment: Alignment.center,
          child: const Text('gif'),
        );
        break;
      case MediaType.video:
        child = Container(
          color: Colors.red,
          alignment: Alignment.center,
          child: const Text('video'),
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
