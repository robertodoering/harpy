import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

/// Overlay for video players that builds compact actions and icons.
///
/// Used in the media timeline.
class SmallVideoPlayerOverlay extends ConsumerWidget {
  const SmallVideoPlayerOverlay({
    required this.child,
    required this.data,
    required this.notifier,
  });

  final Widget child;
  final VideoPlayerStateData data;
  final VideoPlayerNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            onTap: notifier.togglePlayback,
            child: child,
          ),
          VideoPlayerDoubleTapActions(
            notifier: notifier,
            data: data,
            compact: true,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VideoPlayerProgressIndicator(
                  notifier: notifier,
                  compact: true,
                ),
                IconTheme(
                  data: iconTheme.copyWith(size: iconTheme.size! - 4),
                  child: VideoPlayerActions(
                    notifier: notifier,
                    data: data,
                    children: [
                      SizedBox(width: display.smallPaddingValue / 2),
                      VideoPlayerPlaybackButton(
                        data: data,
                        notifier: notifier,
                        padding: EdgeInsets.all(display.smallPaddingValue / 2),
                      ),
                      VideoPlayerMuteButton(
                        data: data,
                        notifier: notifier,
                        padding: EdgeInsets.all(display.smallPaddingValue / 2),
                      ),
                      SizedBox(width: display.smallPaddingValue / 2),
                      const Spacer(),
                      VideoPlayerFullscreenButton(
                        padding: EdgeInsets.all(display.smallPaddingValue / 2),
                      ),
                      SizedBox(width: display.smallPaddingValue / 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (data.isBuffering)
            const ImmediateOpacityAnimation(
              delay: Duration(milliseconds: 500),
              duration: kLongAnimationDuration,
              child: MediaThumbnailIcon(
                icon: CircularProgressIndicator(),
                compact: true,
              ),
            )
          else if (data.isFinished)
            const ImmediateOpacityAnimation(
              duration: kLongAnimationDuration,
              child: MediaThumbnailIcon(
                icon: Icon(Icons.replay),
                compact: true,
              ),
            ),
          if (data.isPlaying)
            AnimatedMediaThumbnailIcon(
              key: ValueKey(data.isPlaying),
              icon: const Icon(Icons.play_arrow_rounded),
              compact: true,
            )
          else
            AnimatedMediaThumbnailIcon(
              key: ValueKey(data.isPlaying),
              icon: const Icon(Icons.pause_rounded),
              compact: true,
            ),
        ],
      ),
    );
  }
}
