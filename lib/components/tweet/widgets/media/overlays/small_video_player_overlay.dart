import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

/// Overlay for video players that builds compact actions and icons.
///
/// Used for videos in the media timeline.
class SmallVideoPlayerOverlay extends ConsumerStatefulWidget {
  const SmallVideoPlayerOverlay({
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
  _SmallVideoPlayerOverlayState createState() =>
      _SmallVideoPlayerOverlayState();
}

class _SmallVideoPlayerOverlayState
    extends ConsumerState<SmallVideoPlayerOverlay>
    with VideoPlayerOverlayMixin {
  @override
  final bool compact = true;

  @override
  void initState() {
    super.initState();

    overlayInit(widget.data);
  }

  @override
  void didUpdateWidget(covariant SmallVideoPlayerOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    overlayUpdate(oldWidget.data, widget.data);
  }

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return GestureDetector(
      // eat all tap gestures that are not handled otherwise (e.g. tapping on
      // the overlay)
      onTap: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.data.isFinished || widget.onVideoTap == null) {
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
            data: widget.data,
            notifier: widget.notifier,
            compact: true,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VideoPlayerProgressIndicator(
                  notifier: widget.notifier,
                  compact: true,
                ),
                IconTheme(
                  data: iconTheme.copyWith(size: iconTheme.size! - 4),
                  child: VideoPlayerActions(
                    data: widget.data,
                    notifier: widget.notifier,
                    children: [
                      SizedBox(width: display.smallPaddingValue / 2),
                      VideoPlayerPlaybackButton(
                        data: widget.data,
                        notifier: widget.notifier,
                        padding: EdgeInsets.all(display.smallPaddingValue / 2),
                      ),
                      VideoPlayerMuteButton(
                        data: widget.data,
                        notifier: widget.notifier,
                        padding: EdgeInsets.all(display.smallPaddingValue / 2),
                      ),
                      SizedBox(width: display.smallPaddingValue / 2),
                      const Spacer(),
                      VideoPlayerFullscreenButton(
                        tweet: widget.tweet,
                        padding: EdgeInsets.all(display.smallPaddingValue / 2),
                      ),
                      SizedBox(width: display.smallPaddingValue / 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.data.isBuffering)
            const ImmediateOpacityAnimation(
              delay: Duration(milliseconds: 500),
              duration: kLongAnimationDuration,
              child: MediaThumbnailIcon(
                icon: CircularProgressIndicator(),
                compact: true,
              ),
            ),
          if (centerIcon != null) centerIcon!,
        ],
      ),
    );
  }
}
