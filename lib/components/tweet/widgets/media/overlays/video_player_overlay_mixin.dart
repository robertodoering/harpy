import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

/// Mixin for video player overlays that show an icon in the center depending
/// its [VideoPlayerStateData].
mixin VideoPlayerOverlayMixin {
  @protected
  Widget? centerIcon;

  @protected
  bool get compact => false;

  void overlayInit(VideoPlayerStateData data) {
    if (data.isFinished && centerIcon == null) {
      // Show the replay icon without an animation when the video player is
      // already finished.
      centerIcon = MediaThumbnailIcon(
        icon: const Icon(Icons.replay),
        compact: compact,
      );
    }
  }

  void overlayUpdate(VideoPlayerStateData oldData, VideoPlayerStateData data) {
    // When we are finished we create the replay icon once and then prevent
    // further changes to the center icon.
    // Otherwise we set the center icon to the current playback state when it
    // changes.
    if (oldData.isFinished != data.isFinished && data.isFinished) {
      centerIcon = _ReplayIcon(compact: compact);
    } else if (data.isFinished) {
      return;
    } else if (oldData.isPlaying != data.isPlaying) {
      if (data.isPlaying) {
        centerIcon = _PlayIcon(compact: compact);
      } else {
        centerIcon = _PauseIcon(compact: compact);
      }
    }
  }
}

class _ReplayIcon extends StatelessWidget {
  const _ReplayIcon({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ImmediateOpacityAnimation(
      key: UniqueKey(),
      duration: theme.animation.long,
      child: MediaThumbnailIcon(
        icon: const Icon(Icons.replay),
        compact: compact,
      ),
    );
  }
}

class _PlayIcon extends StatelessWidget {
  const _PlayIcon({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedMediaThumbnailIcon(
      key: UniqueKey(),
      icon: const Icon(Icons.play_arrow_rounded),
      compact: compact,
    );
  }
}

class _PauseIcon extends StatelessWidget {
  const _PauseIcon({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedMediaThumbnailIcon(
      key: UniqueKey(),
      icon: const Icon(Icons.pause_rounded),
      compact: compact,
    );
  }
}
