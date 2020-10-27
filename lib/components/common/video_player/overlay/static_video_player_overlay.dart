import 'package:flutter/material.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';
import 'package:harpy/components/common/video_player/overlay/content/overlay_action_row.dart';
import 'package:harpy/components/common/video_player/overlay/content/overlay_playback_icon.dart';
import 'package:harpy/components/common/video_player/overlay/content/overlay_replay_icon.dart';

/// Builds a static overlay for a [HarpyVideoPlayer].
///
/// The static overlay always shows the action controls and does not detect
/// gestures when the video is tapped.
class StaticVideoPlayerOverlay extends StatefulWidget {
  const StaticVideoPlayerOverlay(this.model);

  final HarpyVideoPlayerModel model;

  @override
  _StaticVideoPlayerOverlayState createState() =>
      _StaticVideoPlayerOverlayState();
}

class _StaticVideoPlayerOverlayState extends State<StaticVideoPlayerOverlay> {
  Widget _centerIcon;

  HarpyVideoPlayerModel get _model => widget.model;

  @override
  void initState() {
    super.initState();

    _model.addActionListener(_onVideoPlayerAction);
  }

  @override
  void dispose() {
    super.dispose();

    _model.removeActionListener(_onVideoPlayerAction);
  }

  void _onVideoPlayerAction(HarpyVideoPlayerAction action) {
    if (mounted) {
      if (action == HarpyVideoPlayerAction.play) {
        _centerIcon = const OverlayPlaybackIcon.play();
      } else if (action == HarpyVideoPlayerAction.pause) {
        _centerIcon = const OverlayPlaybackIcon.pause();
      }

      // rebuild on action taken
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: OverlayActionRow(widget.model),
        ),
        if (widget.model.finished)
          OverplayReplayIcon(
            onTap: () {}, //todo
          )
        else if (_centerIcon != null)
          _centerIcon,
      ],
    );
  }
}
