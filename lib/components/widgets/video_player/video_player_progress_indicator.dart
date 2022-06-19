import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerProgressIndicator extends StatelessWidget {
  const VideoPlayerProgressIndicator({
    required this.notifier,
    this.compact = false,
  });

  final VideoPlayerNotifier notifier;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Transform(
      alignment: AlignmentDirectional.bottomCenter,
      transform: Matrix4.diagonal3Values(1, compact ? .33 : .66, 1),
      transformHitTests: false,
      child: VideoProgressIndicator(
        notifier.controller,
        allowScrubbing: true,
        // ignore: non_directional
        padding: EdgeInsets.only(top: compact ? 12 : 24),
        colors: VideoProgressColors(
          playedColor: theme.colorScheme.primary.withOpacity(.7),
          bufferedColor: theme.colorScheme.primary.withOpacity(.3),
        ),
      ),
    );
  }
}
