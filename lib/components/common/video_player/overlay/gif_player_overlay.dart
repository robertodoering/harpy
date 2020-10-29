import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/explicit/fade_animation.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';

/// Builds an overlay for a [HarpyGifPlayer].
class GifPlayerOverlay extends StatefulWidget {
  const GifPlayerOverlay(
    this.model, {
    @required this.child,
  });

  final HarpyVideoPlayerModel model;
  final Widget child;

  @override
  _GifPlayerOverlayState createState() => _GifPlayerOverlayState();
}

class _GifPlayerOverlayState extends State<GifPlayerOverlay> {
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
      setState(() {
        if (action == HarpyVideoPlayerAction.play) {
          _centerIcon = null;
        } else if (action == HarpyVideoPlayerAction.pause) {
          _centerIcon = _buildCenterIcon();
        }
      });
    }
  }

  Widget _buildCenterIcon() {
    return Center(
      child: FadeAnimation(
        curve: Curves.easeInOut,
        duration: kShortAnimationDuration,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black45,
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.gif,
            color: Colors.white,
            size: kVideoPlayerCenterIconSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        if (widget.child != null) widget.child,
        if (_centerIcon != null) Positioned.fill(child: _centerIcon),
      ],
    );
  }
}
