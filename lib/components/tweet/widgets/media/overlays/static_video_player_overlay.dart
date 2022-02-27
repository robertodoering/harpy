import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:video_player/video_player.dart';

class StaticVideoPlayerOverlay extends StatelessWidget {
  const StaticVideoPlayerOverlay({
    required this.child,
    required this.notifier,
    required this.data,
  });

  final Widget child;
  final HarpyVideoPlayerNotifier notifier;
  final HarpyVideoPlayerStateData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          //onTap: notifier.togglePlayback,
          child: child,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform(
                transform: Matrix4.diagonal3Values(1, .15, 1),
                transformHitTests: false,
                child: Transform(
                  transform: Matrix4.diagonal3Values(1, 6, 1),
                  alignment: Alignment.bottomCenter,
                  child: VideoProgressIndicator(
                    notifier.controller,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: theme.colorScheme.primary.withOpacity(.7),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  HarpyButton.icon(
                    icon: Icon(
                      data.isPlaying
                          ? CupertinoIcons.pause
                          : CupertinoIcons.play,
                    ),
                    onTap: notifier.togglePlayback,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!data.isPlaying)
          IgnorePointer(
            child: MediaThumbnailIcon(
              icon: Transform.translate(
                offset: const Offset(3, 0),
                child: const Icon(CupertinoIcons.play),
              ),
            ),
          ),
      ],
    );
  }
}
