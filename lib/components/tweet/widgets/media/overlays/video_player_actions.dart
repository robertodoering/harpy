import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class VideoPlayerActions extends ConsumerWidget {
  const VideoPlayerActions({
    required this.data,
    required this.notifier,
    required this.children,
  });

  final VideoPlayerStateData data;
  final VideoPlayerNotifier notifier;
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      child: Row(children: children),
    );
  }
}

class VideoPlayerPlaybackButton extends ConsumerWidget {
  const VideoPlayerPlaybackButton({
    required this.data,
    required this.notifier,
    this.padding,
    this.onPlay,
    this.onPause,
  });

  final VideoPlayerStateData data;
  final VideoPlayerNotifier notifier;
  final EdgeInsets? padding;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return HarpyButton.icon(
      icon: Icon(
        data.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        color: Colors.white,
      ),
      padding: padding ?? EdgeInsets.all(display.smallPaddingValue),
      onTap: () {
        HapticFeedback.lightImpact();
        notifier.togglePlayback();
        data.isPlaying ? onPause?.call() : onPlay?.call();
      },
    );
  }
}

class VideoPlayerMuteButton extends ConsumerWidget {
  const VideoPlayerMuteButton({
    required this.data,
    required this.notifier,
    this.padding,
  });

  final VideoPlayerStateData data;
  final VideoPlayerNotifier notifier;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return HarpyButton.icon(
      icon: Icon(
        data.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
        color: Colors.white,
      ),
      padding: padding ?? EdgeInsets.all(display.smallPaddingValue),
      onTap: () {
        HapticFeedback.lightImpact();
        notifier.toggleMute();
      },
    );
  }
}

class VideoPlayerProgressText extends StatelessWidget {
  const VideoPlayerProgressText({
    required this.data,
  });

  final VideoPlayerStateData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      '${prettyPrintDuration(data.position)} / '
      '${prettyPrintDuration(data.duration)}',
      style: theme.textTheme.bodyText1!.copyWith(
        color: Colors.white,
        height: 1,
      ),
    );
  }
}

class VideoPlayerQualityButton extends ConsumerWidget {
  const VideoPlayerQualityButton({
    required this.data,
    required this.notifier,
  });

  final VideoPlayerStateData data;
  final VideoPlayerNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return HarpyButton.icon(
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
    );
  }
}

class VideoPlayerFullscreenButton extends ConsumerWidget {
  const VideoPlayerFullscreenButton({
    this.padding,
  });

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return HarpyButton.icon(
      icon: const Icon(Icons.fullscreen, color: Colors.white),
      padding: padding ?? EdgeInsets.all(display.smallPaddingValue),
      // TODO: fullscreen video
      onTap: () {
        // HapticFeedback.lightImpact();
      },
    );
  }
}

void _showQualityBottomSheet(
  BuildContext context,
  Reader read, {
  required VideoPlayerStateData data,
  required VideoPlayerNotifier notifier,
}) {
  showHarpyBottomSheet<void>(
    context,
    harpyTheme: read(harpyThemeProvider),
    children: [
      const BottomSheetHeader(child: Text('video quality')),
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
