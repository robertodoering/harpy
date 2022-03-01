import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class DynamicVideoPlayerOverlay extends StatelessWidget {
  const DynamicVideoPlayerOverlay({
    required this.child,
    required this.notifier,
    required this.data,
  });

  final Widget child;
  final VideoPlayerNotifier notifier;
  final VideoPlayerStateData data;

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
          const IgnorePointer(
            child: MediaThumbnailIcon(icon: Icon(Icons.gif)),
          ),
      ],
    );
  }
}
