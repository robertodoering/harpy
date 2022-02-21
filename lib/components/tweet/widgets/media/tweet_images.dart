import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/services/connectivity_service.dart';

class TweetImages extends ConsumerWidget {
  const TweetImages({
    required this.tweet,
  });

  final TweetData tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    return TweetImagesLayout(
      onImageTap: (index) {}, // TODO: implement overlay
      onImageLongPress: (index) {}, // TODO: implement media bottom sheet
      children: [
        for (final image in tweet.media)
          HarpyImage(
            imageUrl: image.appropriateUrl(mediaPreferences, connectivity),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
      ],
    );
  }
}
