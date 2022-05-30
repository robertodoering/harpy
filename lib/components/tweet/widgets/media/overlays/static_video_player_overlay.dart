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

class _StaticVideoPlayerOverlayState extends State<StaticVideoPlayerOverlay>
    with VideoPlayerOverlayMixin {
  @override
  void initState() {
    super.initState();

    overlayInit(widget.data);
  }

  @override
  void didUpdateWidget(covariant StaticVideoPlayerOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    overlayUpdate(oldWidget.data, widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // eat all tap gestures that are not handled otherwise (e.g. tapping on
      // the overlay)
      onTap: () {},
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.data.isFinished ||
                  !widget.data.isPlaying ||
                  widget.onVideoTap == null) {
                HapticFeedback.lightImpact();
                widget.notifier.togglePlayback();
              } else {
                widget.onVideoTap?.call();
              }
            },
            onLongPress: widget.onVideoLongPress,
            child: widget.child,
          ),
          VideoPlayerDoubleTapActions(
            notifier: widget.notifier,
            data: widget.data,
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
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
            ImmediateOpacityAnimation(
              delay: const Duration(milliseconds: 500),
              duration: kLongAnimationDuration,
              child: const MediaThumbnailIcon(
                icon: CircularProgressIndicator(),
              ),
            ),
          if (centerIcon != null) centerIcon!,
        ],
      ),
    );
  }
}
