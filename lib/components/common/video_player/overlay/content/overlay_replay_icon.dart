import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/explicit/fade_animation.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';

/// Builds a replay icon for the center in the video overlay that can fade in.
class OverplayReplayIcon extends StatelessWidget {
  const OverplayReplayIcon({
    this.fadeIn = true,
    this.onTap,
  });

  final bool fadeIn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Widget replayIcon = GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: const Icon(
          Icons.replay,
          size: kVideoPlayerCenterIconSize,
          color: Colors.white,
        ),
      ),
    );

    return Center(
      child: fadeIn
          ? FadeAnimation(
              key: ValueKey<int>(Icons.replay.codePoint),
              child: replayIcon,
            )
          : replayIcon,
    );
  }
}
