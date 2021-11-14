import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// The size for icons appearing in the center of the video player
const double kVideoPlayerCenterIconSize = 48;
const double kVideoPlayerSmallCenterIconSize = 32;

typedef OnVideoPlayerTap = void Function(HarpyVideoPlayerModel model);

typedef OnVideoPlayerLongPress = void Function();

/// Builds a [VideoPlayer] with a overlay to control the video.
///
/// When built initially, the video will not be initialized and instead the
/// [thumbnail] url is used to build an image in place of the video. After being
/// tapped the video will be initialized and starts playing.
///
/// A [HarpyVideoPlayerModel] is used to control the video.
class HarpyVideoPlayer extends StatefulWidget {
  const HarpyVideoPlayer.fromController(
    this.controller, {
    this.thumbnail,
    this.thumbnailAspectRatio,
    this.autoplay = false,
    this.onVideoPlayerTap,
    this.onVideoPlayerLongPress,
    this.allowVerticalOverflow = false,
    this.compact = false,
  }) : model = null;

  const HarpyVideoPlayer.fromModel(
    this.model, {
    this.thumbnail,
    this.thumbnailAspectRatio,
    this.autoplay = false,
    this.onVideoPlayerTap,
    this.onVideoPlayerLongPress,
    this.allowVerticalOverflow = false,
    this.compact = false,
  }) : controller = null;

  final VideoPlayerController? controller;

  /// An optional url to a thumbnail that is built when the video is not
  /// initialized.
  final String? thumbnail;
  final double? thumbnailAspectRatio;

  final HarpyVideoPlayerModel? model;
  final bool autoplay;
  final OnVideoPlayerTap? onVideoPlayerTap;
  final OnVideoPlayerLongPress? onVideoPlayerLongPress;
  final bool allowVerticalOverflow;
  final bool compact;

  @override
  _HarpyVideoPlayerState createState() => _HarpyVideoPlayerState();
}

class _HarpyVideoPlayerState extends State<HarpyVideoPlayer> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();

    if (widget.model == null) {
      _controller = widget.controller;
    } else {
      _controller = widget.model!.controller;
    }
  }

  @override
  void dispose() {
    if (widget.model == null) {
      _controller!.dispose();
    }

    super.dispose();
  }

  void _onVideoTap(HarpyVideoPlayerModel model) {
    if (widget.onVideoPlayerTap == null) {
      if (model.finished) {
        model.replay();
      } else {
        model.togglePlayback();
      }
    } else {
      widget.onVideoPlayerTap!(model);
    }
  }

  /// Builds a [VideoThumbnail] that will start to initialize the video when
  /// tapped.
  Widget _buildUninitialized(HarpyVideoPlayerModel model) {
    return VideoThumbnail(
      thumbnail: widget.thumbnail,
      aspectRatio: widget.thumbnailAspectRatio,
      icon: Icons.play_arrow,
      compact: widget.compact,
      initializing: model.initializing,
      onTap: model.initialize,
      onLongPress: widget.onVideoPlayerLongPress,
    );
  }

  Widget _buildVideo(HarpyVideoPlayerModel model) {
    Widget child = Stack(
      children: [
        AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
        Positioned.fill(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _onVideoTap(model),
                  onDoubleTap: model.fastRewind,
                  onLongPress: widget.onVideoPlayerLongPress,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _onVideoTap(model),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _onVideoTap(model),
                  onDoubleTap: model.fastForward,
                  onLongPress: widget.onVideoPlayerLongPress,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (widget.allowVerticalOverflow) {
      child = OverflowBox(
        minHeight: 0,
        maxHeight: double.infinity,
        child: child,
      );
    }

    return StaticVideoPlayerOverlay(
      model,
      compact: widget.compact,
      child: child,
    );
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final hero = flightDirection == HeroFlightDirection.push
        ? fromHeroContext.widget as Hero
        : toHeroContext.widget as Hero;

    final tween = BorderRadiusTween(
      begin: const BorderRadius.all(kRadius),
      end: BorderRadius.zero,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: tween.evaluate(animation),
        child: hero.child,
      ),
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    final model = context.watch<HarpyVideoPlayerModel>();

    var child =
        !model.initialized ? _buildUninitialized(model) : _buildVideo(model);

    if (widget.autoplay) {
      child = VideoAutoplay(
        onAutoplay: () => _controller?.setVolume(0),
        child: child,
      );
    }

    return Hero(
      tag: model,
      flightShuttleBuilder: _flightShuttleBuilder,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model != null) {
      return ChangeNotifierProvider<HarpyVideoPlayerModel>.value(
        value: widget.model!,
        builder: _builder,
      );
    } else {
      return ChangeNotifierProvider<HarpyVideoPlayerModel>(
        create: (_) => HarpyVideoPlayerModel(_controller),
        builder: _builder,
      );
    }
  }
}
