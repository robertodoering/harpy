import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: harpyTheme.borderRadius,
      child: AspectRatio(
        aspectRatio: entry.media.aspectRatioDouble,
        child: HarpyImage(
          imageUrl: entry.media.appropriateUrl(mediaPreferences, connectivity),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
