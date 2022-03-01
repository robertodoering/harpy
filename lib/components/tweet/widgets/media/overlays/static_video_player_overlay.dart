import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class StaticVideoPlayerOverlay extends ConsumerWidget {
  const StaticVideoPlayerOverlay({
    required this.child,
    required this.notifier,
    required this.data,
  });

  final Widget child;
  final VideoPlayerNotifier notifier;
  final VideoPlayerStateData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: notifier.togglePlayback,
          child: child,
        ),
        VideoPlayerDoubleTapActions(
          notifier: notifier,
          data: data,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VideoPlayerProgressIndicator(notifier: notifier),
              _VideoPlayerActions(notifier: notifier, data: data),
            ],
          ),
        ),
        if (data.isFinished)
          const IgnorePointer(
            child: ImmediateOpacityAnimation(
              duration: kLongAnimationDuration,
              child: MediaThumbnailIcon(
                icon: Icon(Icons.replay),
              ),
            ),
          )
        else if (data.isPlaying)
          AnimatedMediaThumbnailIcon(
            key: ValueKey(data.isPlaying),
            icon: const Icon(Icons.play_arrow_rounded),
          )
        else
          AnimatedMediaThumbnailIcon(
            key: ValueKey(data.isPlaying),
            icon: const Icon(Icons.pause_rounded),
          ),
      ],
    );
  }
}

class _VideoPlayerActions extends ConsumerWidget {
  const _VideoPlayerActions({
    required this.notifier,
    required this.data,
  });

  final VideoPlayerNotifier notifier;
  final VideoPlayerStateData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    final style = theme.textTheme.bodyText1!.copyWith(
      color: Colors.white,
      height: 1,
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black45,
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          smallHorizontalSpacer,
          HarpyButton.icon(
            icon: Icon(
              data.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(display.smallPaddingValue),
            onTap: notifier.togglePlayback,
          ),
          HarpyButton.icon(
            icon: Icon(
              data.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(display.smallPaddingValue),
            onTap: notifier.toggleMute,
          ),
          smallHorizontalSpacer,
          Text(
            '${prettyPrintDuration(data.position)} / '
            '${prettyPrintDuration(data.duration)}',
            style: style,
          ),
          const Spacer(),
          if (data.qualities.length > 1) ...[
            HarpyButton.icon(
              icon: const Icon(
                Icons.video_settings_rounded,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(display.smallPaddingValue),
              onTap: () => _showQualityBottomSheet(
                context,
                ref.read,
                notifier: notifier,
                data: data,
              ),
            ),
            smallHorizontalSpacer,
          ],
          HarpyButton.icon(
            icon: const Icon(Icons.fullscreen, color: Colors.white),
            padding: EdgeInsets.all(display.smallPaddingValue),
            // TODO: fullscreen video
            onTap: () {},
          ),
          smallHorizontalSpacer,
        ],
      ),
    );
  }
}

void _showQualityBottomSheet(
  BuildContext context,
  Reader read, {
  required VideoPlayerNotifier notifier,
  required VideoPlayerStateData data,
}) {
  showHarpyBottomSheet<void>(
    context,
    harpyTheme: read(harpyThemeProvider),
    children: [
      const BottomSheetHeader(child: Text('quality')),
      for (final quality in data.qualities.entries)
        HarpyRadioTile<String>(
          value: quality.key,
          groupValue: data.quality,
          onChanged: (value) {
            HapticFeedback.lightImpact();
            notifier.changeQuality(value);
            Navigator.of(context).pop();
          },
          title: Text(quality.key),
        ),
    ],
  );
}
