import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

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
        alignment: Alignment.center,
        children: [
          HarpyImage(
            imageUrl: thumbnail.appropriateUrl(mediaPreferences, connectivity),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          center,
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

    return IgnorePointer(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black45,
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
      ),
    );
  }
}

class AnimatedMediaThumbnailIcon extends StatelessWidget {
  const AnimatedMediaThumbnailIcon({
    required this.icon,
    Key? key,
  }) : super(key: key);

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return ImmediateScaleAnimation(
      duration: kLongAnimationDuration,
      curve: Curves.easeOutCubic,
      begin: .8,
      end: 1.2,
      child: ImmediateOpacityAnimation(
        duration: kLongAnimationDuration,
        begin: 1,
        end: 0,
        child: MediaThumbnailIcon(
          icon: icon,
        ),
      ),
    );
  }
}
