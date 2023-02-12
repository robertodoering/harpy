import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

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
          begin: AlignmentDirectional.bottomCenter,
          end: AlignmentDirectional.topCenter,
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

class VideoPlayerPlaybackButton extends StatelessWidget {
  const VideoPlayerPlaybackButton({
    required this.data,
    required this.notifier,
    this.padding,
  });

  final VideoPlayerStateData data;
  final VideoPlayerNotifier notifier;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RbyButton.transparent(
      icon: Icon(
        data.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        color: Colors.white,
      ),
      padding: padding ?? EdgeInsets.all(theme.spacing.small),
      onTap: () {
        HapticFeedback.lightImpact();
        notifier.togglePlayback();
      },
    );
  }
}

class VideoPlayerMuteButton extends StatelessWidget {
  const VideoPlayerMuteButton({
    required this.data,
    required this.notifier,
    this.padding,
  });

  final VideoPlayerStateData data;
  final VideoPlayerNotifier notifier;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RbyButton.transparent(
      icon: Icon(
        data.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
        color: Colors.white,
      ),
      padding: padding ?? EdgeInsets.all(theme.spacing.small),
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
      style: theme.textTheme.bodyLarge!.copyWith(
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
    final theme = Theme.of(context);

    return RbyButton.transparent(
      icon: const Icon(
        Icons.video_settings_rounded,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(theme.spacing.small),
      onTap: () => _showQualityBottomSheet(
        ref,
        notifier: notifier,
        data: data,
      ),
    );
  }
}

class VideoPlayerFullscreenButton extends StatelessWidget {
  const VideoPlayerFullscreenButton({
    required this.tweet,
    this.padding,
  });

  final LegacyTweetData tweet;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RbyButton.transparent(
      icon: const Icon(Icons.fullscreen_rounded, color: Colors.white),
      padding: padding ?? EdgeInsets.all(theme.spacing.small),
      onTap: () => Navigator.of(context).push<void>(
        HeroDialogRoute(
          builder: (_) => TweetFullscreenVideo(tweet: tweet),
        ),
      ),
    );
  }
}

class VideoPlayerCloseFullscreenButton extends StatelessWidget {
  const VideoPlayerCloseFullscreenButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RbyButton.transparent(
      icon: const Icon(Icons.fullscreen_exit_rounded, color: Colors.white),
      padding: EdgeInsets.all(theme.spacing.small),
      onTap: Navigator.of(context).pop,
    );
  }
}

void _showQualityBottomSheet(
  WidgetRef ref, {
  required VideoPlayerStateData data,
  required VideoPlayerNotifier notifier,
}) {
  showRbyBottomSheet<void>(
    ref.context,
    children: [
      const BottomSheetHeader(child: Text('video quality')),
      for (final quality in data.qualities.entries)
        RbyRadioTile<String>(
          value: quality.key,
          groupValue: data.quality,
          onChanged: (value) {
            HapticFeedback.lightImpact();
            notifier.changeQuality(value);
            Navigator.of(ref.context).pop();
          },
          title: Text(quality.key),
        ),
    ],
  );
}
