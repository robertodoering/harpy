import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/explicit/animation_constants.dart';
import 'package:harpy/components/common/animations/explicit/fade_animation.dart';
import 'package:harpy/components/common/animations/explicit/transform_animation.dart';
import 'package:harpy/components/common/animations/implicit/animated_icon.dart';
import 'package:harpy/components/common/buttons/circle_button.dart';
import 'package:harpy/components/common/video_player/harpy_video_player.dart';
import 'package:harpy/components/common/video_player/harpy_video_player_model.dart';
import 'package:harpy/misc/utils/string_utils.dart';
import 'package:video_player/video_player.dart';

/// Builds the overlay for a [HarpyVideoPlayer].
///
/// The overlay hides automatically after a certain amount of time.
class VideoPlayerOverlay extends StatefulWidget {
  const VideoPlayerOverlay(this.model);

  final HarpyVideoPlayerModel model;

  @override
  _VideoPlayerOverlayState createState() => _VideoPlayerOverlayState();
}

class _VideoPlayerOverlayState extends State<VideoPlayerOverlay>
    with TickerProviderStateMixin<VideoPlayerOverlay> {
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

  HarpyVideoPlayerModel get model => widget.model;

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

    model.addActionListener(_onVideoPlayerAction);
    model.controller.addListener(_videoControllerListener);

    if (!model.playing) {
      // show overlay when building overlay with the player paused (e.g. when
      // toggling fullscreen)
      _opacityController.value = 1;
      _hideOverlayController.reset();
    }

    // disable the fade-in animation of the replay icon when the video is
    // already finished (entering fullscreen when replay button is visible)
    _replayFade = !model.finished;
  }

  @override
  void dispose() {
    _hideOverlayController.dispose();
    _opacityController.dispose();
    model.removeActionListener(_onVideoPlayerAction);

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
    if (status == AnimationStatus.completed && !model.finished) {
      // start hiding overlay automatically after a certain amount of time
      // (when the video has not finished)
      _hideOverlayController.forward();
    }
  }

  void _videoControllerListener() {
    if (model.finished && mounted) {
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

          _centerIcon = const _OverlayPlaybackIcon.play();

          break;
        case HarpyVideoPlayerAction.pause:
          // constantly show overlay
          _hideOverlayController.reset();
          if (_opacityController.isAnimating) {
            _opacityController.forward();
          }

          _centerIcon = const _OverlayPlaybackIcon.pause();

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
    if (model.finished) {
      _replayFade = true;
      model.replay();
    } else if (_show) {
      // if the overlay is already showing, play / pause the video
      model.togglePlayback();
    } else {
      _opacityController.forward();
    }
  }

  Widget _buildReplayIcon() {
    final Widget replayIcon = Container(
      decoration: BoxDecoration(
        color: Colors.black38,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(
        Icons.replay,
        size: kVideoPlayerCenterIconSize,
        color: Colors.white,
      ),
    );

    return Center(
      child: _replayFade
          ? FadeAnimation(
              key: ValueKey<int>(Icons.replay.codePoint),
              child: replayIcon,
            )
          : replayIcon,
    );
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
              child: _OverlayActionRow(model),
            ),
          ),
        if (model.finished)
          _buildReplayIcon()
        else if (_centerIcon != null)
          _centerIcon,
      ],
    );
  }
}

/// Builds a play or pause icon in the center that fades out automatically.
class _OverlayPlaybackIcon extends StatelessWidget {
  const _OverlayPlaybackIcon.play() : icon = Icons.play_arrow;

  const _OverlayPlaybackIcon.pause() : icon = Icons.pause;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeAnimation(
        key: ValueKey<int>(icon.codePoint),
        curve: Curves.easeInOut,
        fadeType: FadeType.fadeOut,
        child: TransformInAnimation.scale(
          beginScale: 1,
          endScale: 1.5,
          curve: Curves.easeInOutSine,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: kVideoPlayerCenterIconSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Builds the actions at the bottom of the overlay.
class _OverlayActionRow extends StatelessWidget {
  const _OverlayActionRow(this.model);

  final HarpyVideoPlayerModel model;

  Widget _buildBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.transparent,
              Colors.black45,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(HarpyVideoPlayerModel model, ThemeData theme) {
    return Transform(
      transform: Matrix4.diagonal3Values(1, .66, 1),
      alignment: Alignment.bottomCenter,
      transformHitTests: false,
      child: VideoProgressIndicator(
        model.controller,
        allowScrubbing: true,
        colors: VideoProgressColors(
          playedColor: theme.accentColor.withOpacity(.7),
        ),
      ),
    );
  }

  Widget _buildActions(HarpyVideoPlayerModel model, ThemeData theme) {
    return Row(
      children: <Widget>[
        if (model.finished)
          // replay button
          CircleButton(
            onTap: model.replay,
            child: Icon(
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
        _OverlayPositionText(model),
        Expanded(
          child: Text(
            ' / ${prettyPrintDuration(model.duration)}',
            style: theme.textTheme.bodyText2.apply(color: Colors.white),
          ),
        ),

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
    final ThemeData theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        _buildBackground(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildProgressIndicator(model, theme),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: _buildActions(model, theme),
            ),
          ],
        ),
      ],
    );
  }
}

/// Builds the current position as a text and updates it automatically.
class _OverlayPositionText extends StatefulWidget {
  const _OverlayPositionText(this.model);

  final HarpyVideoPlayerModel model;

  @override
  _OverlayPositionTextState createState() => _OverlayPositionTextState();
}

class _OverlayPositionTextState extends State<_OverlayPositionText> {
  @override
  void initState() {
    super.initState();

    widget.model.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.model.controller.removeListener(_listener);

    super.dispose();
  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      prettyPrintDuration(widget.model.position),
      style: Theme.of(context).textTheme.bodyText2.apply(color: Colors.white),
    );
  }
}
