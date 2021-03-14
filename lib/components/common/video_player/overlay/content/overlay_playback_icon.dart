import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/explicit/fade_animation.dart';
import 'package:harpy/components/common/animations/explicit/transform_animation.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';

/// Builds a play or pause icon in the center that fades out automatically.
class OverlayPlaybackIcon extends StatelessWidget {
  const OverlayPlaybackIcon.play({
    this.compact = false,
  }) : icon = Icons.play_arrow;

  const OverlayPlaybackIcon.pause({
    this.compact = false,
  }) : icon = Icons.pause;

  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeAnimation(
        key: ValueKey<int>(icon.codePoint),
        curve: Curves.easeInOut,
        fadeType: FadeType.fadeOut,
        child: TransformInAnimation.scale(
          beginScale: 1,
          endScale: 1.5,
          curve: Curves.easeInOutSine,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: compact
                  ? kVideoPlayerSmallCenterIconSize
                  : kVideoPlayerCenterIconSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
