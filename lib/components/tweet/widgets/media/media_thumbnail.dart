import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class MediaThumbnail extends ConsumerWidget {
  const MediaThumbnail({
    required this.thumbnail,
    required this.center,
    this.onTap,
  });

  final ImageMediaData thumbnail;
  final Widget center;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          HarpyImage(
            imageUrl: thumbnail.appropriateUrl(mediaPreferences, connectivity),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(child: center),
        ],
      ),
    );
  }
}

class MediaThumbnailIcon extends StatelessWidget {
  const MediaThumbnailIcon({
    required this.icon,
  });

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black54,
      ),
      child: Theme(
        data: theme.copyWith(
          progressIndicatorTheme: theme.progressIndicatorTheme.copyWith(
            color: Colors.white,
          ),
          iconTheme: theme.iconTheme.copyWith(
            size: 42,
            color: Colors.white,
          ),
        ),
        child: SizedBox(
          width: 42,
          height: 42,
          child: icon,
        ),
      ),
    );
  }
}
