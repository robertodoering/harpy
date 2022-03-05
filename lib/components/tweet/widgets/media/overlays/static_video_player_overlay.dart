import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class StaticVideoPlayerOverlay extends ConsumerStatefulWidget {
  const StaticVideoPlayerOverlay({
    required this.child,
    required this.data,
    required this.notifier,
    this.onVideoTap,
  });

  final Widget child;
  final VideoPlayerStateData data;
  final VideoPlayerNotifier notifier;
  final VoidCallback? onVideoTap;

  @override
  _StaticVideoPlayerOverlayState createState() =>
      _StaticVideoPlayerOverlayState();
}

class _StaticVideoPlayerOverlayState
    extends ConsumerState<StaticVideoPlayerOverlay> {
  Widget? _playbackIcon;

  void _showPlay() {
    setState(
      () => _playbackIcon = AnimatedMediaThumbnailIcon(
        key: UniqueKey(),
        icon: const Icon(Icons.play_arrow_rounded),
      ),
    );
  }

  void _showPause() {
    setState(
      () => _playbackIcon = AnimatedMediaThumbnailIcon(
        key: UniqueKey(),
        icon: const Icon(Icons.pause_rounded),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // eat all tap gestures that are not handled otherwise (e.g. tapping on
      // the overlay)
      onTap: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: widget.onVideoTap ??
                () {
                  HapticFeedback.lightImpact();
                  widget.notifier.togglePlayback();
                  widget.data.isPlaying ? _showPause() : _showPlay();
                },
            child: widget.child,
          ),
          VideoPlayerDoubleTapActions(
            notifier: widget.notifier,
            data: widget.data,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VideoPlayerProgressIndicator(notifier: widget.notifier),
                VideoPlayerActions(
                  data: widget.data,
                  notifier: widget.notifier,
                  children: [
                    smallHorizontalSpacer,
                    VideoPlayerPlaybackButton(
                      notifier: widget.notifier,
                      data: widget.data,
                      onPlay: _showPlay,
                      onPause: _showPause,
                    ),
                    VideoPlayerMuteButton(
                      notifier: widget.notifier,
                      data: widget.data,
                    ),
                    smallHorizontalSpacer,
                    VideoPlayerProgressText(data: widget.data),
                    const Spacer(),
                    if (widget.data.qualities.length > 1)
                      VideoPlayerQualityButton(
                        data: widget.data,
                        notifier: widget.notifier,
                      ),
                    const VideoPlayerFullscreenButton(),
                    smallHorizontalSpacer,
                  ],
                ),
              ],
            ),
          ),
          if (widget.data.isBuffering)
            const ImmediateOpacityAnimation(
              delay: Duration(milliseconds: 500),
              duration: kLongAnimationDuration,
              child: MediaThumbnailIcon(icon: CircularProgressIndicator()),
            )
          else if (widget.data.isFinished)
            const ImmediateOpacityAnimation(
              duration: kLongAnimationDuration,
              child: MediaThumbnailIcon(
                icon: Icon(Icons.replay),
              ),
            ),
          if (_playbackIcon != null) _playbackIcon!,
        ],
      ),
    );
  }
}
