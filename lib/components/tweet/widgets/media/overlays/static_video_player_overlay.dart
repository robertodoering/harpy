import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

/// Overlay for video players where the UI elements are always visible.
///
/// Used for videos in tweet cards.
class StaticVideoPlayerOverlay extends StatefulWidget {
  const StaticVideoPlayerOverlay({
    required this.child,
    required this.tweet,
    required this.notifier,
    required this.data,
    this.onVideoTap,
    this.onVideoLongPress,
  });

  final Widget child;
  final TweetData tweet;
  final VideoPlayerNotifier notifier;
  final VideoPlayerStateData data;
  final VoidCallback? onVideoTap;
  final VoidCallback? onVideoLongPress;

  @override
  _StaticVideoPlayerOverlayState createState() =>
      _StaticVideoPlayerOverlayState();
}

class _StaticVideoPlayerOverlayState extends State<StaticVideoPlayerOverlay> {
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
            onLongPress: widget.onVideoLongPress,
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
                    VideoPlayerFullscreenButton(tweet: widget.tweet),
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
