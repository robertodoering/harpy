import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class GifVideoPlayerOverlay extends StatelessWidget {
  const GifVideoPlayerOverlay({
    required this.child,
    required this.notifier,
    required this.data,
    this.compact = false,
  });

  final Widget child;
  final VideoPlayerNotifier notifier;
  final VideoPlayerStateData data;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: notifier.togglePlayback,
          child: child,
        ),
        if (!data.isPlaying)
          ImmediateOpacityAnimation(
            duration: kShortAnimationDuration,
            child: MediaThumbnailIcon(
              icon: const Icon(Icons.gif),
              compact: compact,
            ),
          ),
      ],
    );
  }
}
