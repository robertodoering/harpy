import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds an icon for the vide player overlay that fades and scales out
/// automatically.
class VideoOverlayIcon extends StatelessWidget {
  const VideoOverlayIcon({
    required this.icon,
    this.compact = false,
  });

  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
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
      ),
    );
  }
}

/// The play icon built in the center for the video player overlay.
class OverlayIconPlay extends StatelessWidget {
  const OverlayIconPlay({
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VideoOverlayIcon(
        icon: Icons.play_arrow,
        compact: compact,
      ),
    );
  }
}

/// The pause icon built in the center for the video player overlay.
class OverlayIconPause extends StatelessWidget {
  const OverlayIconPause({
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VideoOverlayIcon(
        icon: Icons.pause,
        compact: compact,
      ),
    );
  }
}

/// The fast forward icon built on the right side of the video player overlay.
class OverlayIconForward extends StatelessWidget {
  OverlayIconForward({
    this.compact = false,
  }) : super(key: UniqueKey());

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Expanded(
          child: VideoOverlayIcon(
            icon: Icons.fast_forward,
            compact: compact,
          ),
        ),
      ],
    );
  }
}

/// The fast rewind icon built on the right side of the video player overlay.
class OverlayIconRewind extends StatelessWidget {
  OverlayIconRewind({
    this.compact = false,
  }) : super(key: UniqueKey());

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VideoOverlayIcon(
            icon: Icons.fast_rewind,
            compact: compact,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
