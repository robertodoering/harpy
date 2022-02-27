import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

class GifVideoPlayerOverlay extends StatelessWidget {
  const GifVideoPlayerOverlay({
    required this.child,
    required this.notifier,
    required this.data,
  });

  final Widget child;
  final HarpyVideoPlayerNotifier notifier;
  final HarpyVideoPlayerStateData data;

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
