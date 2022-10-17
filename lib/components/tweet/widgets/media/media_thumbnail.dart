import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class MediaThumbnail extends ConsumerWidget {
  const MediaThumbnail({
    required this.thumbnail,
    required this.center,
    this.duration,
    this.onTap,
    this.onLongPress,
  });

  final ImageMediaData thumbnail;
  final Widget center;
  final Duration? duration;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    return GestureDetector(
      // if no tap handler is given we set an empty one to prevent gestures to
      // propagate
      onTap: onTap ?? () {},
      onLongPress: onLongPress,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          HarpyImage(
            imageUrl: thumbnail.appropriateUrl(mediaPreferences, connectivity),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            catchGesturesOnError: false,
          ),
          center,
          if (duration != null) _ThumbnailDuration(duration: duration!),
        ],
      ),
    );
  }
}

class MediaThumbnailIcon extends StatelessWidget {
  const MediaThumbnailIcon({
    required this.icon,
    this.compact = false,
  });

  final Widget icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IgnorePointer(
      child: Container(
        padding: compact ? const EdgeInsets.all(8) : const EdgeInsets.all(12),
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
              size: compact ? 32 : 42,
              color: Colors.white,
            ),
          ),
          child: SizedBox(
            width: compact ? 32 : 42,
            height: compact ? 32 : 42,
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
    this.compact = false,
    super.key,
  });

  final Widget icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ImmediateScaleAnimation(
      duration: theme.animation.long,
      curve: Curves.easeOutCubic,
      begin: .8,
      end: 1.2,
      child: ImmediateOpacityAnimation(
        duration: theme.animation.long,
        begin: 1,
        end: 0,
        child: MediaThumbnailIcon(
          icon: icon,
          compact: compact,
        ),
      ),
    );
  }
}

class _ThumbnailDuration extends StatelessWidget {
  const _ThumbnailDuration({
    required this.duration,
  });

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IgnorePointer(
      child: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.base / 2,
            vertical: theme.spacing.base / 3,
          ),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: theme.shape.borderRadius,
          ),
          child: Text(
            prettyPrintDuration(duration),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(.8),
            ),
          ),
        ),
      ),
    );
  }
}
