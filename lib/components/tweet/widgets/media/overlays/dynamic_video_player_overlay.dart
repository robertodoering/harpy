import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';

/// Overlay for video players where the UI elements automatically hide to avoid
/// obscuring the content.
///
/// Used for fullscreen videos.
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
    // TODO: build dynamic fullscreen video overlay

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
