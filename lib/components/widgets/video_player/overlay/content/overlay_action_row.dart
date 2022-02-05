import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:video_player/video_player.dart';

/// Builds the actions at the bottom of the overlay.
class OverlayActionRow extends StatelessWidget {
  const OverlayActionRow(
    this.model, {
    this.compact = false,
  });

  final HarpyVideoPlayerModel model;
  final bool compact;

  BoxDecoration get _backgroundDecoration => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black45,
          ],
        ),
      );

  Widget _buildProgressIndicator(HarpyVideoPlayerModel model, ThemeData theme) {
    return Transform(
      transform: Matrix4.diagonal3Values(1, .66, 1),
      alignment: Alignment.bottomCenter,
      transformHitTests: false,
      child: VideoProgressIndicator(
        model.controller!,
        allowScrubbing: true,
        colors: VideoProgressColors(
          playedColor: theme.colorScheme.primary.withOpacity(.7),
        ),
      ),
    );
  }

  Widget _buildActions(HarpyVideoPlayerModel model, ThemeData theme) {
    return Row(
      children: [
        if (model.finished)
          // replay button
          CircleButton(
            onTap: model.replay,
            child: const Icon(
              Icons.replay,
              color: Colors.white,
            ),
          )
        else
          // play / pause icon
          CircleButton(
            onTap: model.togglePlayback,
            child: ImplicitlyAnimatedIcon(
              icon: AnimatedIcons.play_pause,
              color: Colors.white,
              animatedIconState: model.playing
                  ? AnimatedIconState.showSecond
                  : AnimatedIconState.showFirst,
            ),
          ),

        // toggle mute icon
        CircleButton(
          onTap: model.toggleMute,
          child: Icon(
            model.muted ? Icons.volume_off : Icons.volume_up,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),

        // position text
        if (model.fullscreen || !compact) ...[
          OverlayPositionText(model),
          Expanded(
            child: Text(
              ' / ${prettyPrintDuration(model.duration)}',
              style: theme.textTheme.bodyText2!.apply(color: Colors.white),
            ),
          ),
        ] else
          const Spacer(),

        // toggle fullscreen
        CircleButton(
          onTap: model.toggleFullscreen,
          child: Icon(
            model.fullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: _backgroundDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: compact
                ? const EdgeInsets.symmetric(horizontal: 12)
                : const EdgeInsets.symmetric(horizontal: 16),
            child: _buildProgressIndicator(model, theme),
          ),
          Padding(
            padding: compact ? EdgeInsets.zero : const EdgeInsets.all(4),
            child: _buildActions(model, theme),
          ),
        ],
      ),
    );
  }
}
