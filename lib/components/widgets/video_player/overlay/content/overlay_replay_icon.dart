import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds a replay icon for the center in the video overlay that can fade in.
class OverplayReplayIcon extends StatelessWidget {
  const OverplayReplayIcon({
    this.fadeIn = true,
    this.compact = false,
    this.onTap,
  });

  final bool fadeIn;
  final bool compact;
  final VoidCallback? onTap;

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
        child: Icon(
          Icons.replay,
          size: compact
              ? kVideoPlayerSmallCenterIconSize
              : kVideoPlayerCenterIconSize,
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
