import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class GifVideoPlayerOverlay extends StatelessWidget {
  const GifVideoPlayerOverlay({
    required this.child,
    required this.notifier,
    required this.data,
    this.compact = false,
    this.onGifTap,
  });

  final Widget child;
  final VideoPlayerNotifier notifier;
  final VideoPlayerStateData data;
  final bool compact;
  final VoidCallback? onGifTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: onGifTap ??
              () {
                HapticFeedback.lightImpact();
                notifier.togglePlayback();
              },
          child: child,
        ),
        AnimatedOpacity(
          opacity: data.isPlaying ? 0 : 1,
          duration: kShortAnimationDuration,
          curve: Curves.easeInOut,
          child: MediaThumbnailIcon(
            icon: const Icon(Icons.gif),
            compact: compact,
          ),
        ),
      ],
    );
  }
}
