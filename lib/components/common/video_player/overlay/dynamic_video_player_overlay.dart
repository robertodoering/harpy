import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';
import 'package:harpy/components/common/video_player/overlay/content/overlay_action_row.dart';
import 'package:harpy/components/common/video_player/overlay/content/overlay_playback_icon.dart';
import 'package:harpy/components/common/video_player/overlay/content/overlay_replay_icon.dart';

/// Builds a dynamic overlay for a [HarpyVideoPlayer].
///
/// The overlay hides automatically after a certain amount of time.
class DynamicVideoPlayerOverlay extends StatefulWidget {
  const DynamicVideoPlayerOverlay(this.model);

  final HarpyVideoPlayerModel model;

  @override
  _DynamicVideoPlayerOverlayState createState() =>
      _DynamicVideoPlayerOverlayState();
}

class _DynamicVideoPlayerOverlayState extends State<DynamicVideoPlayerOverlay>
    with TickerProviderStateMixin<DynamicVideoPlayerOverlay> {
  /// Handles automatically hiding the overlay.
  ///
  /// When the controller completes, it resets and starts reversing the
  /// [_opacityController] assuming it is completed.
  AnimationController _hideOverlayController;

  /// Handles the opacity animation for the overlay.
  ///
  /// When the controller completes, it starts the [_hideOverlayController] that
  /// will eventually reverse this controller.
  AnimationController _opacityController;
  Animation<double> _opacityAnimation;

  /// The center play / pause icon.
  ///
  /// Stored in the instance to prevent the fade animation to play when entering
  /// fullscreen.
  Widget _centerIcon;

  /// Whether the replay icon should fade in when the video finishes.
  ///
  /// Used to prevent the fade-in animation to play when entering fullscreen
  /// with the video already finished and the icon showing.
  bool _replayFade = true;

  HarpyVideoPlayerModel get _model => widget.model;

  /// Whether to show the overlay.
  bool get _show => _opacityController.status != AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();

    _hideOverlayController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addStatusListener(_hideOverlayStatusListener);

    _opacityController = AnimationController(
      vsync: this,
      duration: kShortAnimationDuration,
    )
      ..addListener(_opacityListener)
      ..addStatusListener(_opacityStatusListener);

    _opacityAnimation = CurveTween(
      curve: Curves.easeInOut,
    ).animate(_opacityController);

    _model.addActionListener(_onVideoPlayerAction);
    _model.controller.addListener(_videoControllerListener);

    if (!_model.playing) {
      // show overlay when building overlay with the player paused (e.g. when
      // toggling fullscreen)
      _opacityController.value = 1;
      _hideOverlayController.reset();
    }

    // disable the fade-in animation of the replay icon when the video is
    // already finished (entering fullscreen when replay button is visible)
    _replayFade = !_model.finished;
  }

  @override
  void dispose() {
    _hideOverlayController.dispose();
    _opacityController.dispose();
    _model.removeActionListener(_onVideoPlayerAction);
    _model.controller.removeListener(_videoControllerListener);

    super.dispose();
  }

  void _hideOverlayStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _hideOverlayController.reset();

      // start hiding overlay
      if (_opacityController.status == AnimationStatus.completed) {
        _opacityController.reverse();
      }
    }
  }

  void _opacityListener() {
    if (mounted) {
      setState(() {});
    }
  }

  void _opacityStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_model.finished) {
      // start hiding overlay automatically after a certain amount of time
      // (when the video has not finished)
      _hideOverlayController.forward();
    }
  }

  void _videoControllerListener() {
    if (_model.finished && mounted) {
      // when finished, show the overlay and set state to build the replay icon
      // in the center
      setState(() {
        _hideOverlayController.reset();
        _opacityController.forward();
      });
    }
  }

  void _onVideoPlayerAction(HarpyVideoPlayerAction action) {
    if (mounted) {
      switch (action) {
        case HarpyVideoPlayerAction.play:
          // hide overlay
          _opacityController.reverse();

          _centerIcon = const OverlayPlaybackIcon.play();

          break;
        case HarpyVideoPlayerAction.pause:
          // constantly show overlay
          _hideOverlayController.reset();
          if (_opacityController.isAnimating) {
            _opacityController.forward();
          }

          _centerIcon = const OverlayPlaybackIcon.pause();

          break;
        case HarpyVideoPlayerAction.mute:
        case HarpyVideoPlayerAction.unmute:
          // reset auto hide timer
          _hideOverlayController
            ..reset()
            ..forward();
          if (_opacityController.isAnimating) {
            _opacityController.forward();
          }
          break;
      }

      // rebuild on action taken
      setState(() {});
    }
  }

  void _onVideoTap() {
    if (_model.finished) {
      _replayFade = true;
      _model.replay();
    } else if (_show) {
      // if the overlay is already showing, play / pause the video
      _model.togglePlayback();
    } else {
      _opacityController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: _onVideoTap,
        ),
        if (_show)
          Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: OverlayActionRow(_model),
            ),
          ),
        if (_model.finished)
          OverplayReplayIcon(
            fadeIn: _replayFade,
            onTap: _onVideoTap,
          )
        else if (_centerIcon != null)
          _centerIcon,
      ],
    );
  }
}
