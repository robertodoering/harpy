import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

/// Overlay for video players where the UI elements automatically hide to avoid
/// obscuring the content.
///
/// Used for fullscreen videos.
class DynamicVideoPlayerOverlay extends StatefulWidget {
  const DynamicVideoPlayerOverlay({
    required this.child,
    required this.notifier,
    required this.data,
  });

  final Widget child;
  final VideoPlayerNotifier notifier;
  final VideoPlayerStateData data;

  @override
  State<DynamicVideoPlayerOverlay> createState() =>
      _DynamicVideoPlayerOverlayState();
}

class _DynamicVideoPlayerOverlayState extends State<DynamicVideoPlayerOverlay> {
  late bool _showActions = !widget.data.isPlaying;

  Widget? _playbackIcon;

  @override
  void didUpdateWidget(covariant DynamicVideoPlayerOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    _showActions = !widget.data.isPlaying;
  }

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
            onTap: () {
              HapticFeedback.lightImpact();
              widget.data.isPlaying ? _showPause() : _showPlay();
              widget.notifier.togglePlayback();
            },
            child: widget.child,
          ),
          VideoPlayerDoubleTapActions(
            notifier: widget.notifier,
            data: widget.data,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(
              ignoring: !_showActions,
              child: AnimatedSlide(
                offset: _showActions ? Offset.zero : const Offset(0, .33),
                duration: kShortAnimationDuration,
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: _showActions ? 1 : 0,
                  duration: kShortAnimationDuration,
                  curve: Curves.easeInOut,
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
                          const VideoPlayerCloseFullscreenButton(),
                          smallHorizontalSpacer,
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
