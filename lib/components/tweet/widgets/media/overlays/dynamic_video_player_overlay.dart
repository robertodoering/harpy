import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

/// Overlay for video players where the UI elements automatically hide to avoid
/// obscuring the content.
///
/// Used for fullscreen videos.
class DynamicVideoPlayerOverlay extends StatefulWidget {
  const DynamicVideoPlayerOverlay({
    required this.child,
    required this.tweet,
    required this.notifier,
    required this.data,
    this.isFullscreen = false,
  });

  final Widget child;
  final LegacyTweetData tweet;
  final VideoPlayerNotifier notifier;
  final VideoPlayerStateData data;
  final bool isFullscreen;

  @override
  State<DynamicVideoPlayerOverlay> createState() =>
      _DynamicVideoPlayerOverlayState();
}

class _DynamicVideoPlayerOverlayState extends State<DynamicVideoPlayerOverlay>
    with VideoPlayerOverlayMixin {
  Timer? _timer;
  bool _showActions = true;

  @override
  void initState() {
    super.initState();

    overlayInit(widget.data);

    if (widget.data.isPlaying) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => setState(() => _showActions = false),
      );
    }
  }

  @override
  void didUpdateWidget(covariant DynamicVideoPlayerOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.data.isFinished) {
      _showActions = true;
    } else if (oldWidget.data.isPlaying != widget.data.isPlaying) {
      _showActions = !widget.data.isPlaying;
    }

    overlayUpdate(oldWidget.data, widget.data);
  }

  void _scheduleHideActions() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showActions = !widget.data.isPlaying);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      // eat all tap gestures that are not handled otherwise (e.g. tapping on
      // the overlay)
      onTap: () {},
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          GestureDetector(
            onTap: () {
              if (_showActions) {
                HapticFeedback.lightImpact();
                widget.notifier.togglePlayback();
              } else {
                setState(() => _showActions = true);
                _scheduleHideActions();
              }
            },
            child: widget.child,
          ),
          VideoPlayerDoubleTapActions(
            notifier: widget.notifier,
            data: widget.data,
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: ClipRect(
              child: IgnorePointer(
                ignoring: !_showActions,
                child: AnimatedSlide(
                  offset: _showActions ? Offset.zero : const Offset(0, .33),
                  duration: theme.animation.short,
                  curve: Curves.easeOut,
                  child: AnimatedOpacity(
                    opacity: _showActions ? 1 : 0,
                    duration: theme.animation.short,
                    curve: Curves.easeInOut,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        VideoPlayerProgressIndicator(notifier: widget.notifier),
                        VideoPlayerActions(
                          data: widget.data,
                          notifier: widget.notifier,
                          children: [
                            HorizontalSpacer.small,
                            VideoPlayerPlaybackButton(
                              notifier: widget.notifier,
                              data: widget.data,
                            ),
                            VideoPlayerMuteButton(
                              notifier: widget.notifier,
                              data: widget.data,
                            ),
                            HorizontalSpacer.small,
                            VideoPlayerProgressText(data: widget.data),
                            const Spacer(),
                            if (widget.data.qualities.length > 1)
                              VideoPlayerQualityButton(
                                data: widget.data,
                                notifier: widget.notifier,
                              ),
                            if (widget.isFullscreen)
                              const VideoPlayerCloseFullscreenButton()
                            else
                              VideoPlayerFullscreenButton(tweet: widget.tweet),
                            HorizontalSpacer.small,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.data.isBuffering)
            ImmediateOpacityAnimation(
              delay: const Duration(milliseconds: 500),
              duration: theme.animation.long,
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
